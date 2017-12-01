import strutils
import parseutils
import streams

when not defined(js):
  import struct
  import os, ospaths
  import zip/zipfiles


type TimeZoneError* = object of Exception
type AmbiguousTimeError* = object of Exception
type NonExistentTimeError* = object of Exception

type
  TZFileHeader* = object ## Header of a compiled Olson TZ file
    magic*:      string ## The identification magic number of TZ Data files.
    version*:    int8 ## The version of the TZ Data File
    ttisgmtcnt*: int ## The number of UTC/local indicators stored in the file.
    ttisstdcnt*: int ## The number of standard/wall indicators stored in the file.
    leapcnt*:    int ## The number of leap seconds for which data is stored in the file.
    timecnt*:    int ## The number of "transition times" for which data is stored in the file.
    typecnt*:    int ## The number of "local time types" for which data is stored in the file (must not be zero).
    charcnt*:    int ## The number of characters of "timezone abbreviation strings" stored in the file.


  TimeTypeInfo* = object ## offsets and TZ name abbreviations as found in Olson TZ files
    gmtoff*: int
    isdst*: int8
    isstd*: bool
    isgmt*: bool
    abbrev*: string


  LeapSecondInfo* = tuple ## leap second descriptions in v2 Olson TZ files
    transitionTime: BiggestInt
    correction: int


  TZFileData* = object ## to collect data from Olson TZ files
    version*: int8
    header*: TZFileHeader
    transitionTimes*: seq[BiggestInt]
    timeInfoIdx*: seq[int]
    timeInfos*: seq[TimeTypeInfo]
    leapSecondInfos*: seq[LeapSecondInfo]


  TZFileContent* = object ## to collect v0 and v2 data in a Olson TZ file
    version*: int
    transitionData*: seq[TZFileData]
    posixTZ*: string


  TransitionInfo* = object ## point in time and description of a DST transition in Olson files
    time*: BiggestInt
    data*: TimeTypeInfo


  RuleType* = enum ## the three possibilities to express DST transitions in a Posix TZ string
    rJulian1, rJulian0, rMonth

  DstTransitionRule* = ref DstTransitionRuleObj
  DstTransitionRuleObj* = object ## variant object to store DST transition rules from Posix TZ strings
    case kind*: RuleType
    of rJulian0:
      dstYDay*: range[0..365]
    of rJulian1:
      dstNLYDay*: range[1..365]
    of rMonth:
      dstWDay*: range[1..7]
      dstWeek*: range[1..5]
      dstMonth*: range[1..12]
    dstTransitionTime*: int


  TZRuleData* = object ## to store the data in a Posix TZ string
    stdName*: string
    dstName*: string
    utcOffset*: int
    dstOffset*: int
    dstStartRule*: DstTransitionRule
    dstEndRule*: DstTransitionRule


  TZType* = enum ## the two kinds of TZ descriptions currently supported
    tzPosix, tzOlson


  TZInfo* = ref TZInfoObj
  TZInfoObj* = object ## a variant object to store either Olson or Posix TZ definitions
    case kind*: TZType
    of tzPosix:
      posixData*: TZRuleData
    of tzOlson:
      olsonData*: TZFileContent


const DEFAULT_TRANSITION_TIME = 7200
const DEFAULT_DST_OFFSET = -3600

template myDebugEcho(x: varargs[untyped]) =
  when defined(debug):
    debugEcho(x)


proc getOffset(numberStr: string): int =
  ## handles the various possibilities to express
  ## UTC- or DST-offsets in the Posix TZ description
  ##
  let nlen = len(numberStr)
  var hours, minutes, seconds = 0

  case nlen
  of 1, 2:
    hours = parseInt(numberStr)
  of 3, 4:
    hours = parseInt(numberStr[0..1])
    minutes = parseInt(numberStr[2..^1])
  of 5, 6:
    hours = parseInt(numberStr[0..1])
    minutes = parseInt(numberStr[2..3])
    seconds = parseInt(numberStr[4..^1])
  else:
    result = -1
  result = hours * 3600 + minutes * 60 + seconds


proc parseOffset(tzstr: string, value: var int, start = 0): int =
  ## parses an UTC or DST offset as given in the Posix TZ description
  ##
  var curr = start
  var numberStr = ""
  var sign = 1
  var i = parseWhile(tzstr, numberStr, {'+', '-', '0'..'9'}, curr)
  if i == 0:
    return i
  if numberStr[0] == '-':
    sign = -1
  if i == 0:
    return 0
  if numberStr[0] in {'-', '+'}:
    numberStr = numberStr[1..^1]
  let offset = getOffset(numberStr)
  if offset < 0:
    return 0
  value = offset
  curr += i
  if len(numberStr) <= 2 and tzstr[curr] == ':':
    inc(curr)
    i = parseWhile(tzstr, numberStr, {'0'..'9'}, curr)
    if i == 0:
      return 0
    value += parseInt(numberStr) * 60
    curr += i

    if curr >= len(tzstr):
      value = sign * value
      return curr

    if tzstr[curr] == ':':
      inc(curr)
      i = parseWhile(tzstr, numberStr, {'0'..'9'}, curr)
      if i == 0:
        return 0
      value += parseInt(numberStr)
      curr += i
  value = sign * value
  return curr


proc parseMonthRule(tzstr: string, rule: var DstTransitionRule, start: int): int =
  ## parses the month rule in a DST transition rule according
  ## to the Posix TZ description
  ##
  var curr = start
  var i = 0
  var numberstr = ""
  i = parseUntil(tzstr, numberstr, '.', curr)
  if i == 0:
    return 0
  let month = parseInt(numberstr)
  if month < 1 or month > 12:
    return 0
  curr += i + 1

  i = parseUntil(tzstr, numberstr, '.', curr)
  if i == 0:
    return 0
  let week = parseInt(numberstr)
  if week < 1 or week > 5:
    return 0
  curr += i + 1

  i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
  if i == 0:
    return 0
  var wday = parseInt(numberstr)
  if wday < 0 or wday > 6:
    return 0
  else:
    wday = if wday == 0: 7 else: wday
  inc(curr)
  rule = DstTransitionRule(kind: rMonth,
                          dstMonth: month,
                          dstWeek: week,
                          dstWDay: wday,
                          dstTransitionTime: DEFAULT_TRANSITION_TIME)
  return curr


proc parseDstRule(tzstr: string, rd: var TZRuleData, start: int, dstStart: bool): int =
  ## parses the DST Rule part of a Posix TZ description
  ##
  var curr = start
  var numberstr = ""
  var i = 0
  var rule: DstTransitionRule
  var yday: int

  if tzstr[start] == 'M':
    inc(curr)
    i = parseMonthRule(tzstr, rule, curr)
    if i == 0:
      return 0
    curr = i
  else:
    if tzstr[start] == 'J':
      inc(curr)
      i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
      if i == 0:
        return 0
      yday = parseInt(numberstr)
      if yday < 1 or yday > 365:
        return 0
      rule = DstTransitionRule(kind: rJulian1,
                                dstNLYDay: yday,
                                dstTransitionTime: DEFAULT_TRANSITION_TIME)
    else:
      i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
      if i == 0:
        return 0
      yday = parseInt(numberstr)
      if yday < 0 or yday > 365:
        return 0
      rule = DstTransitionRule(kind: rJulian0,
                                dstYDay: yday,
                                dstTransitionTime: DEFAULT_TRANSITION_TIME)
    curr += i

  var dstTransitionTime = DEFAULT_TRANSITION_TIME
  if tzstr[curr] == '/':
    inc(curr)
    i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
    if i == 0:
      return 0
    dstTransitionTime = parseInt(numberstr) * 3600
    curr += i

    if tzstr[curr] == ':':
      inc(curr)
      i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
      if i == 0:
        return 0
      curr += i
      dstTransitionTime += parseInt(numberstr) * 60
      if tzstr[curr] == ':':
        inc(curr)
        i = parseWhile(tzstr, numberstr, {'0'..'9'}, curr)
        if i == 0:
          return 0
        dstTransitionTime += parseInt(numberstr)
        curr += i
    rule.dstTransitionTime = dstTransitionTime

  if dstStart:
    rd.dstStartRule = rule
  else:
    rd.dstEndRule = rule

  return curr


proc parsetz*(tzstr: string, ruleData: var TZRuleData): bool =
  ## parses a Posix TZ definition, as described in the manual page
  ## for `tzset<https://linux.die.net/man/3/tzset>`__
  ##
  var i: int = 0
  var curr: int = i
  var strlen = len(tzstr)
  myDebugEcho(align("TZ name: ", 15), tzstr[curr..^1])
  if tzstr[0] == '<':
    i = parseUntil(tzstr, ruleData.stdName, '>')
    if i == 0:
      raise newException(ValueError, "parsing TZ name failed")
    ruleData.stdName.add(">")
    curr = i + 1
  else:
    i = parseUntil(tzstr, ruleData.stdName, {'+', '-', '0'..'9'}, 0)
    if i == 0:
      raise newException(ValueError, "parsing TZ name failed")
    curr = i

  if curr >= strlen:
    raise newException(ValueError, "no UTC offset found")

  myDebugEcho(align("UTC offset: ", 15), tzstr[curr..^1])
  i = parseOffset(tzstr, ruleData.utcOffset, curr)
  if i == 0:
    raise newException(ValueError, "parsing UTC offset failed")
  curr = i

  if curr >= strlen:
    return true

  myDebugEcho(align("DST name: ", 15), tzstr[curr..^1])
  if tzstr[0] == '<':
    i = parseUntil(tzstr, ruleData.dstName, '>', curr)
    if i == 0:
      raise newException(ValueError, "parsing DST name failed")
    ruleData.dstName.add(">")
    curr += i + 1
  else:
    i = parseUntil(tzstr, ruleData.dstName, {',', '+', '-', '0'..'9'}, curr)
    if i == 0:
      raise newException(ValueError, "parsing DST name failed")
    curr += i

  ruleData.dstOffset = ruleData.utcOffset + DEFAULT_DST_OFFSET

  if curr >= strlen:
    ruleData.dstStartRule =
      DstTransitionRule(kind: rMonth,
                        dstWday: 7, #Sunday
                        dstWeek: 5,
                        dstMonth: 3,
                        dstTransitionTime: DEFAULT_TRANSITION_TIME)
    ruleData.dstEndRule =
      DstTransitionRule(kind: rMonth,
                        dstWday: 7, #Sunday
                        dstWeek: 5,
                        dstMonth: 10,
                        dstTransitionTime: DEFAULT_TRANSITION_TIME)
    return true

  var startRuleFlag = true
  if tzstr[curr] == ',':
    myDebugEcho(align("DST rule: ", 15), tzstr[curr..^1], " ", startRuleFlag)
    ruleData.dstOffset = ruleData.utcOffset + DEFAULT_DST_OFFSET
    inc(curr)
    i = parseDstRule(tzstr, ruleData, curr, startRuleFlag)
    if i == 0:
      raise newException(ValueError, "parsing DST start rule failed")
    curr = i
    startRuleFlag = false
  else:
    myDebugEcho(align("DST offset: ", 15), tzstr[curr..^1])

    i = parseOffset(tzstr, ruleData.dstOffset, curr)
    if i == 0:
      raise newException(ValueError, "parsing DST offset failed")
    ruleData.dstOffset = ruleData.utcOffset + ruleData.dstOffset
    curr = i

  myDebugEcho(align("DST rule: ", 15), tzstr[curr..^1], " ", startRuleFlag)
  if tzstr[curr] == ',':
    inc(curr)
    i = parseDstRule(tzstr, ruleData, curr, startRuleFlag)
    if i == 0:
      if startRuleFlag:
        raise newException(ValueError, "parsing DST start rule failed")
      else:
        raise newException(ValueError, "parsing DST end rule failed")

    curr = i
    startRuleFlag = false

  myDebugEcho(align("DST rule: ", 15), tzstr[curr..^1], " ", startRuleFlag)
  if tzstr[curr] == ',':
    inc(curr)
    i = parseDstRule(tzstr, ruleData, curr, startRuleFlag)
    if i == 0:
      if startRuleFlag:
        raise newException(ValueError, "parsing DST start rule failed")
      else:
        raise newException(ValueError, "parsing DST end rule failed")
    curr = i

  return true


when not defined(js):
  proc readTZData*(tzdata: Stream, zoneName = ""): TZFileContent =
    ## reads a compiled Olson TZ Database file
    ##
    ## adapted from similar code in Pythons
    ## `dateutil <https://pypi.python.org/pypi/python-dateutil>`__
    ## package and in the `IANA Time Zone database <https://www.iana.org/time-zones>`__
    ##
    var fp = tzdata

    result.transitionData = @[]
    result.posixTZ = "UTC"

    var v2 = false

    proc readBlock(fp: Stream, blockNr = 1): TZFileData =
      var magic = fp.readStr(4)

      if $magic != "TZif":
        raise newException(ValueError, zoneName & " is not a timezone file")

      let version = fp.readInt8() - ord('0')
      if version == 2:
        v2 = true

      discard fp.readStr(15)

      # from man 5 tzfile
      #[
        Timezone information files begin with a 44-byte header structured as follows:
              *  The magic four-byte sequence "TZif" identifying this as a timezone information file.
              *  A single character identifying the version of the file's format: either an ASCII NUL ('\0') or a '2' (0x32).
              *  Fifteen bytes containing zeros reserved for future use.
              *  Six four-byte values of type long, written in a "standard" byte order (the high-order byte of the value is  written  first).   These
                  values are, in order:
                  tzh_ttisgmtcnt
                        The number of UTC/local indicators stored in the file.
                  tzh_ttisstdcnt
                        The number of standard/wall indicators stored in the file.
                  tzh_leapcnt
                        The number of leap seconds for which data is stored in the file.
                  tzh_timecnt
                        The number of "transition times" for which data is stored in the file.
                  tzh_typecnt
                        The number of "local time types" for which data is stored in the file (must not be zero).
                  tzh_charcnt
                        The number of characters of "timezone abbreviation strings" stored in the file.
      ]#

      var rData = TZFileData()

      rData.version = version

      var hdr = TZFileHeader()
      hdr.magic = magic
      if v2 and blockNr == 1:
        hdr.version = 0
      else:
        hdr.version = 2
      hdr.ttisgmtcnt = unpack(">i", fp.readStr(4))[0].getInt()
      hdr.ttisstdcnt = unpack(">i", fp.readStr(4))[0].getInt()
      hdr.leapcnt = unpack(">i", fp.readStr(4))[0].getInt()
      hdr.timecnt = unpack(">i", fp.readStr(4))[0].getInt()
      hdr.typecnt = unpack(">i", fp.readStr(4))[0].getInt()
      hdr.charcnt = unpack(">i", fp.readStr(4))[0].getInt()

      rData.header = hdr

      #[
        The  above  header  is  followed  by tzh_timecnt four-byte values of type long,
        sorted in ascending order. These values are written in "standard" byte order.
        Each is used as a transition time (as returned by time(2)) at which the rules
        for computing local time  change.
      ]#

      var transition_times: seq[BiggestInt] = @[]
      for i in 1..hdr.timecnt:
        if blockNr == 1:
          transition_times.add(unpack(">i", fp.readStr(4))[0].getInt)
        else:
          transition_times.add(unpack(">q", fp.readStr(8))[0].getQuad)
      rData.transitionTimes = transition_times

      #[
        Next come tzh_timecnt one-byte values of type unsigned
        char; each one tells which of the different types of
        ``local time`` types described in the file is associated
        with the same-indexed transition time. These values
        serve as indices into an array of ttinfo structures that
        appears next in the file.
      ]#

      var transition_idx: seq[int] = @[]
      for i in 1..hdr.timecnt:
        transition_idx.add(fp.readUInt8().int)
      rData.timeInfoIdx = transition_idx

      #[
        Each structure is written as a four-byte value for tt_gmtoff of type long,
        in a standard byte order, followed by a one-byte value for
        tt_isdst and a one-byte value for tt_abbrind.  In each structure,
        tt_gmtoff gives the number of seconds to be added  to  UTC,
        tt_isdst tells whether tm_isdst should be set by localtime(3), and
        tt_abbrind serves as an index into the array of timezone abbreviation
        characters that follow the ttinfo structure(s) in the file.
      ]#
      var ttinfos: seq[TimeTypeInfo] = @[]
      var abbrIdx: seq[int] = @[]

      for i in 1..hdr.typecnt:
        var tmp: TimeTypeInfo
        tmp.gmtoff = unpack(">i", fp.readStr(4))[0].getInt()
        tmp.isdst = fp.readInt8()
        abbrIdx.add(fp.readUInt8().int)
        ttinfos.add(tmp)

      var timezone_abbreviations = fp.readStr(hdr.charcnt)

      for i in 0 .. high(abbrIdx):
        let x = abbrIdx[i]
        ttinfos[i].abbrev = $timezone_abbreviations[x .. find(timezone_abbreviations, "\0", start=x) - 1]

      #[
        Then there are tzh_leapcnt pairs of four-byte values, written in standard byte order;
        the first value of each pair gives the time (as returned by time(2)) at which a leap
        second occurs;
        the second gives the total number of leap seconds to be applied after the given
        time. The pairs of values are sorted in ascending order by time.
      ]#
      var leapSecInfos: seq[LeapSecondInfo] = @[]
      for i in 1..hdr.leapcnt:
        var tmp: LeapSecondInfo
        if blockNr == 1:
          tmp.transitionTime = unpack(">i", fp.readStr(4))[0].getInt()
        else:
          tmp.transitionTime = unpack(">q", fp.readStr(8))[0].getQuad()
        tmp.correction = unpack(">i", fp.readStr(4))[0].getInt()
        leapSecInfos.add(tmp)

      rData.leapSecondInfos = leapSecInfos

      #[
        Then there are tzh_ttisstdcnt standard/wall indicators, each stored as a one-byte value;
        they tell whether the transition times associated with local time types were specified
        as standard time or wall clock time, and are used when a timezone file is used in
        handling POSIX-style timezone environment variables.
      ]#

      for i in 1..hdr.ttisstdcnt:
        let isStd = fp.readInt8()
        if isStd == 1:
          ttinfos[i - 1].isStd = true
        else:
          ttinfos[i - 1].isStd = false

      #[
        Finally, there are tzh_ttisgmtcnt UTC/local indicators, each stored as a one-byte value;
        they tell whether the transition times associated with local time types were specified as
        UTC or local time, and are used when a timezone file is used in handling POSIX-style time‐
        zone environment variables.
      ]#
      for i in 1..hdr.ttisgmtcnt:
        let isGMT = fp.readInt8()
        if isGMT == 1:
          ttinfos[i - 1].isGmt = true
        else:
          ttinfos[i - 1].isGmt = false

      rData.timeInfos = ttinfos
      result = rData

    result.transitionData.add(readBlock(fp, 1))
    if v2:
      result.version = 2
      result.transitionData.add(readBlock(fp, 2))
      discard fp.readLine()
      result.posixTZ = fp.readLine()
    fp.close()


  proc readTZFile*(filename: string): TZFileContent =
    var fp = newFileStream(filename, fmRead)
    if not isNil(fp):
      result = readTZData(fp, filename)


  proc readTZZip*(zipname: string, zonename: string): TZFileContent =
    var zip: ZipArchive
    if zip.open(zipname):
      var fp = getStream(zip, zonename)
      if not isNil(fp):
        result = readTZData(fp, zonename)
        zip.close()
      else:
        raise newException(IOError, "failed to read: " & zonename & " from Zip: " & zipname)
    else:
      raise newException(IOError, "failed to open ZIP: " & zipname)


proc getTZInfo*(tzname: string, tztype: TZType = tzPosix): TZInfo =
  case tztype
  of tzPosix:
    try:
      var tzname = tzname
      if tzname.toLowerAscii() == "utc":
        tzname.add("0")
      var rule = TZRuleData()
      if not parsetz(tzname, rule):
        raise newException(TimeZoneError, "can't parse " & tzname & " as a Posix TZ value")
      var tzinfo = TZInfo(kind: tzPosix, posixData: rule)
      result = tzinfo
    except:
      echo "tzPosix: ", getCurrentExceptionMsg()
      #raise getCurrentException()
      return getTZInfo(tzname, tzOlson)
  of tzOlson:
    when defined(js):
      raise newException(TimeZoneError, "Olson timezone files not supported on js backend")
    else:
      var zippath = currentSourcePath
      let zipname = "zoneinfo.zip"
      var tz: TZFileContent
      if fileExists(tzname):
        tz = readTZFile(tzname)
      elif fileExists(zipname):
        tz = readTZZip(zipname, tzname)
      elif fileExists(zippath / zipname):
        tz = readTZZip(zippath / zipname, tzname)
      elif fileExists(parentDir(zippath) / zipname):
        tz = readTZZip(parentDir(zippath) / zipname, tzname)
      else:
        var fullpath = ""
        let timezoneDirs = [
          "/usr/share/zoneinfo",
          "/usr/local/share/zoneinfo",
          "/usr/local/etc/zoneinfo"
        ]
        for dir in timezoneDirs:
          if fileExists(dir / tzname):
            fullpath = dir / tzname
            break
        if fullpath == "":
          raise newException(TimeZoneError, "can't load " & tzname & " as Olson Timezone data. Giving up ...")
        tz = readTZFile(fullpath)
      var tzinfo = TZInfo(kind: tzOlson, olsonData: tz)
      result = tzinfo

proc initTZInfo*(tzname: string, tztype = tzPosix): TZInfo =
  getTZInfo(tzname, tztype)
