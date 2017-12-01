when defined(posix):
  when defined(linux) and defined(amd64):
    type
      Timeval {.importc: "struct timeval",
                header: "<sys/select.h>".} = object ## struct timeval
        tv_sec: clong  ## Seconds.
        tv_usec: clong ## Microseconds.
  else:
    type
      Timeval {.importc: "struct timeval",
                header: "<sys/select.h>".} = object ## struct timeval
        tv_sec: int  ## Seconds.
        tv_usec: int ## Microseconds.


  proc gettimeofday(tp: var Timeval, unused: pointer = nil) {.
    importc: "gettimeofday", header: "<sys/time.h>".}


proc epochTime*(): float =
  when defined(posix):
    var a: Timeval
    gettimeofday(a)
    result = toFloat(a.tv_sec) + toFloat(a.tv_usec)*0.00_0001
  elif defined(windows):
    const
      epochDiff = 116444736000000000'i64
      rateDiff = 10000000'i64 # 100 nsecs

    type FILETIME {.final, pure.} = object ## CANNOT BE int64 BECAUSE OF ALIGNMENT
      dwLowDateTime*: int32
      dwHighDateTime*: int32

    proc getSystemTimeAsFileTime*(lpSystemTimeAsFileTime: var FILETIME) {.
      importc: "GetSystemTimeAsFileTime", dynlib: "kernel32", stdcall.}

    proc rdFileTime*(f: FILETIME): int64 =
      result = ze64(f.dwLowDateTime) or (ze64(f.dwHighDateTime) shl 32)

    var f: FILETIME
    getSystemTimeAsFileTime(f)
    var i64 = rdFileTime(f) - epochDiff
    var secs = i64 div rateDiff
    var subsecs = i64 mod rateDiff
    result = toFloat(int(secs)) + toFloat(int(subsecs)) * 0.0000001
  elif defined(js):
    type JsDate = object
    proc newDate(): JsDate {.importc: "new Date".}
    proc getTime(js: JsDate): int {.importcpp.}
    newDate().getTime() / 1000
  else:
    {.error: "unknown OS".}

