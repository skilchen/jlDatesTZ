import ../../jlDatesTZ
import unittest
import tables
import math

test "Test string/show representation of initDate":
    check $(initDate(1, 1, 1)) == "0001-01-01" # January 1st, 1 AD/CE
    check $(initDate(0, 12, 31)) == "0000-12-31" # December 31, 1 BC/BCE
    check $(initDate(1, 1, 1) - initDate(0, 12, 31)) == $Day(1)
    check Date(instant: UTD(-306)) == initDate(0, 2, 29)
    check $(initDate(0, 1, 1)) == "0000-01-01" # January 1st, 1 BC/BCE
    check $(initDate(-1, 1, 1)) == "-0001-01-01" # January 1st, 2 BC/BCE
    check $(initDate(-1000000, 1, 1)) == "-1000000-01-01"
    check $(initDate(1000000, 1, 1)) == "1000000-01-01"
    check $(initDateTime(2000, 1, 1, 0, 0, 0, 1)) == "2000-01-01T00:00:00.001"
    check $(initDateTime(2000, 1, 1, 0, 0, 0, 2)) == "2000-01-01T00:00:00.002"
    check $(initDateTime(2000, 1, 1, 0, 0, 0, 500)) == "2000-01-01T00:00:00.500"
    check $(initDateTime(2000, 1, 1, 0, 0, 0, 998)) == "2000-01-01T00:00:00.998"
    check $(initDateTime(2000, 1, 1, 0, 0, 0, 999)) == "2000-01-01T00:00:00.999"
    check $(initTime(0)) == "00:00:00"
    check $(initTime(0, 1)) == "00:01:00"
    check $(initTime(0, 1, 2)) == "00:01:02"
    check $(initTime(0, 1, 2, 3)) == "00:01:02.003"
    check $(initTime(0, 1, 2, 3, 4)) == "00:01:02.003004"
    check $(initTime(0, 1, 2, 3, 4, 5)) == "00:01:02.003004005"
    check $(initTime(0, 0, 0, 0, 1)) == "00:00:00.000001"
    check $(initTime(0, 0, 0, 0, 0, 1)) == "00:00:00.000000001"
    check $(initTime(0, 0, 0, 1)) == "00:00:00.001"

test "Common Parsing Patterns":
    #'1996-January-15'
    let dt = initDateTime(1996, 1, 15)
    let f = "%y-%m-%d"
    let a = "96-01-15"
    check strptime(a, f).dt + Year(1900) == dt
    check strftime(dt, f) == a
    let a1 = "96-1-15"
    check strptime(a1, f).dt + Year(1900) == dt
    check strftime(dt, f) == "96-01-15"
    let a2 = "96-1-1"
    check strptime(a2, f).dt + Year(1900) + Day(14) == dt
    check strftime(dt - Day(14), "%y-%m-%d") == "96-01-01"
    let a3 = "1996-1-15"
    check strptime(a3, f).dt == dt
    check strftime(dt, "%y-%m-%d") == "96-01-15"
    let a4 = "1996-Jan-15"
    expect ValueError:
        echo strptime(a4, f)

test "monthname":
    let f = "%y/%b/%d"
    let b = "96/Feb/15"
    let dt = initDateTime(1996, 1, 15)
    check strptime(b, f).dt + Year(1900) == dt + Month(1)
    check strftime(dt + Month(1), f) == b
    let b1 = "1996/Feb/15"
    check strptime(b1, f).dt == dt + Month(1)
    check strftime(dt + Month(1), "%Y/%b/%d") == b1
    let b2 = "96/Feb/1"
    check strptime(b2, f).dt + Year(1900) + Day(14) == dt + Month(1)
    check strftime(dt + Month(1) - Day(14), "%Y/%b/%d") == "1996/Feb/01"
    # Here we've specifed a text month name, but given a number
    let b3 = "96/2/15"
    expect ValueError:
        echo strptime(b3, f).dt
    try:
        echo strptime("2012/2/20T9:9:31.25i90", "%y/%m/%dT%M:%M:%S.%f").dt
        check true
    except:
        echo getCurrentExceptionMsg()

test "colon separator":
    let f = "%y:%d:%m"
    let c = "96:15:01"
    let dt = initDateTime(1996, 1, 15)
    check strptime(c, f).dt + Year(1900) == dt
    check strftime(dt, f) == c
    let c1 = "1996:15:01"
    check strptime(c1, f).dt == dt
    check strftime(dt, "%Y:%d:%m") == c1
    let c2 = "96:15:1"
    check strptime(c2, f).dt + Year(1900) == dt
    check strftime(dt, "%y:%d:%m") == "96:15:01"
    let c3 = "96:1:01"
    check strptime(c3, f).dt + Year(1900) + Day(14) == dt
    check strftime(dt - Day(14), "%y:%m:%d") == "96:01:01"
    let c4 = "1996:15:01 # random comment"
    check strptime(c4, f).dt == dt

test "comma separator":
    let f = "%Y, %b, %d"
    let d = "1996, Jan, 15"
    let dt = initDateTime(1996, 1, 15)
    check strptime(d, f).dt == dt
    check strftime(dt, f) == d
    let d1 = "96, Jan, 15"
    check strptime(d1, f).dt + Year(1900) == dt
    check strftime(dt, "%y, %b, %d") == d1
    let d2 = "1996, Jan, 1"
    check strptime(d2, f).dt + Day(14) == dt
    check strftime(dt - Day(14), "%Y, %b, %d") == "1996, Jan, 01"
    let d3 = "1996, 2, 15"
    expect ValueError:
        echo strptime(d3, f).dt

test "point separator":
    let f = "%Y.%B.%d"
    let e = "1996.January.15"
    let dt = initDateTime(1996, 1, 15)
    check strptime(e, f).dt == dt
    check strftime(dt, f) == e
    let e1 = "96.January.15"
    check strptime(e1, f).dt + Year(1900) == dt
    check strftime(dt, "%y.%B.%d") == e1

test "space separator":
    let fo = "%Y %m %d"
    let f = "1996 1 15"
    let dt = initDateTime(1996, 1, 15)
    check strptime(f, fo).dt == dt
    check strftime(dt, fo) == "1996 01 15"
    let f1 = "1996 01 15"
    check strptime(f1, fo).dt == dt
    check strftime(dt, "%Y %m %d") == f1
    let f2 = "1996 1 1"
    check strptime(f2, fo).dt + Day(14) == dt
    check strftime(dt - Day(14), "%Y %m %d") == "1996 01 01"

test "dash separator":
    let j = "1996-01-15"
    var f = "%Y-%m-%d zzz"
    let dt = initDateTime(1996, 1, 15)
    check strptime(j, f).dt == dt
    check strftime(dt, f) == j & " zzz"
    let k = "1996-01-15 10:00:00"
    f = "%Y-%m-%d %H:%M:%S zzz"
    check strptime(k, f).dt == dt + Hour(10)
    check strftime(dt + Hour(10), f) == k & " zzz"
    let l = "1996-01-15 10:10:10.25"
    f = "%Y-%m-%d %H:%M:%S.%f zzz"
    check strptime(l, f).dt == dt + Hour(10) + Minute(10) + Second(10) + Millisecond(250)
    check strftime(dt + Hour(10) + Minute(10) + Second(10) + Millisecond(250), f) == l & " zzz"

test "slash separator":
    let r = "1/15/1996" # Excel
    var f = "%m/%d/%Y"
    let dt = initDateTime(1996, 1, 15)
    check strptime(r, f).dt == dt
    check strftime(dt, f) == "01/15/1996"
    let s = "19960115"
    f = "%Y%m%d"
    check strptime(s, f).dt == dt
    check strftime(dt, f) == s
    let v = "1996-01-15 10:00:00"
    f = "%Y-%m-%d %H:%M:%S"
    check strptime(v, f).dt == dt + Hour(10)
    check strftime(dt + Hour(10), f) == v
    let w = "1996-01-15T10:00:00"
    f = "%Y-%m-%dT%H:%M:%S zzz"
    check strptime(w, f).dt == dt + Hour(10)
    check strftime(dt + Hour(10), f) == w & " zzz"

    f = "%Y/%m"
    let y = "1996/1"
    check strptime(y, f).dt == dt - Day(14)
    check strftime(dt, f) == "1996/01"
    let y1 = "1996/1/15"
    check strptime(y1, f).dt == dt - Day(14)
    # check_throws ArgumentError initDateTime(y1, f)
    let y2 = "96/1"
    check strptime(y2, f).dt + Year(1900) == dt - Day(14)
    check strftime(dt, "%y/%m") == "96/01"

    f = "%Y"
    let z = "1996"
    check strptime(z, f).dt == dt - Day(14)
    check strftime(dt, f) == z
    let z1 = "1996-3"
    check strptime(z1, f).dt == dt - Day(14)
    check strftime(dt, f) == z
    let z2 = "1996-3-1"
    check strptime(z2, f).dt == dt - Day(14)
    check strftime(dt, f) == z

    let aa = "1/5/1996"
    f = "%m/%d/%Y"
    check strptime(aa, f).dt == dt - Day(10)
    check strftime(dt - Day(10), f) == "01/05/1996"
    let bb = "5/1/1996"
    f = "%d/%m/%Y"
    check strptime(bb, f).dt == dt - Day(10)
    check strftime(dt - Day(10), f) == "05/01/1996"
    let cc = "01151996"
    f = "%m%d%Y"
    check strptime(cc, f).dt == dt
    check strftime(dt, f) == cc
    let dd = "15011996"
    f = "%d%m%Y"
    check strptime(dd, f).dt == dt
    check strftime(dt, f) == dd
    let ee = "01199615"
    f = "%m%Y%d"
    check strptime(ee, f).dt == dt
    check strftime(dt, f) == ee
    let ff = "1996-15-Jan"
    f = "%Y-%d-%b"
    check strptime(ff, f).dt == dt
    check strftime(dt, f) == ff
    let gg = "Jan-1996-15"
    f = "%b-%Y-%d"
    check strptime(gg, f).dt == dt
    check strftime(dt, f) == gg
    let hh = "1996#1#15"
    f = "%Y#%m#%d"
    check strptime(hh, f).dt == dt
    check strftime(dt, f) == "1996#01#15"

test "prefix.":
    let s = "/1996/1/15"
    var f = "/%Y/%m/%d"
    let dt = initDateTime(1996, 1, 15)
    check strptime(s, f).dt == dt
    check strftime(dt, f) == "/1996/01/15"
    check strptime("1996/1/15", f).dt == dt
    # check_throws ArgumentError initDateTime("1996/1/15", f)

    # # from Jiahao
    # currently i don't handle unicode
    # check strptime("2009年12月01日", "%Y年%m月%d日") == initDate(2009, 12, 1)
    # check format(initDate(2009, 12, 1), "yyyy年mm月dd日") == "2009年12月01日"
    # check initDate("2009-12-01", "yyyy-mm-dd") == initDate(2009, 12, 1)

test "French: from Milan":
    let f = "%d/%m/%Y"
    let f2 = "%d/%m/%y"
    check strptime("28/05/2014", f).dt == initDateTime(2014, 5, 28)
    check strptime("28/05/14", f2).dt + Year(2000) == initDateTime(2014, 5, 28)

test "Customizing locale":
    jlDatesTZ.LOCALES["french"] = initDateLocale(
        ["janvier", "février", "mars", "avril", "mai", "juin",
         "juillet", "août", "septembre", "octobre", "novembre", "décembre"],
        ["janv", "févr", "mars", "avril", "mai", "juin",
         "juil", "août", "sept", "oct", "nov", "déc"],
        ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"],
        ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"]
    )
    var f = "%d %b %Y"
    check strptime("28 mai 2014", f, locale="french").dt == initDateTime(2014, 5, 28)
    check strftime(initDateTime(2014, 5, 28), f, locale="french") == "28 mai 2014"
    check strptime("28 févr 2014", f, locale="french").dt == initDateTime(2014, 2, 28)
    check strftime(initDateTime(2014, 2, 28), f, locale="french") == "28 févr 2014"
    check strptime("28 août 2014", f, locale="french").dt == initDateTime(2014, 8, 28)
    check strftime(initDateTime(2014, 8, 28), f, locale="french") == "28 août 2014"
    check strptime("28 avril 2014", f, locale="french").dt == initDateTime(2014, 4, 28)
    check strftime(initDateTime(2014, 4, 28), f, locale="french") == "28 avril 2014"

    f = "%d %b %Y"
    check strptime("28 avril 2014", f, locale="french").dt == initDateTime(2014, 4, 28)
    f = "%d %b %Y"
    # parses 3 and 4 character month names
    check strptime("28 mai 2014", f, locale="french").dt == initDateTime(2014, 5, 28)
    check strptime("28 août 2014", f, locale="french").dt == initDateTime(2014, 8, 28)
    # doesn't parse month name greater than 4 chars
    check strptime("28 avril 2014", f, locale="french").dt == initDateTime(2014, 4, 28)
    # check_throws ArgumentError initDate("28avril2014", f; locale="french")

test "various cases":
# # From Tony Fong
# f = "dduuuyy"
# check initDate("01Dec09", f) + Year(2000) == initDate(2009, 12, 1)
# check format(initDate(2009, 12, 1), f) == "01Dec09"
# f = "dduuuyyyy"
# check initDate("01Dec2009", f) == initDate(2009, 12, 1)
# check format(initDate(2009, 12, 1), f) == "01Dec2009"
# f = "duy"
# const globex = ["f", "g", "h", "j", "k", "m", "n", "q", "u", "v", "x", "z"]
# locale = initDateLocale(globex, map(uppercase, globex), globex[1:7], globex[1:7])
# check initDate("1F4", f; locale=locale) + Year(2010) == initDate(2014, 1, 1)
# check format(initDate(2014, 1, 1), f; locale=locale) == "1F4"

    # From Matt Bauman
    var f = "%Y-%m-%dT%H:%M:%S"
    check strptime("2014-05-28T16:46:04", f).dt == initDateTime(2014, 5, 28, 16, 46, 04)

# # Try to break stuff

    # Specified mm/dd, but date string has day/mm
    expect ValueError:
        echo strptime("18/05/2009", "%m/%d/%Y").dt
        # check_throws ArgumentError initDateTime("18/05/2009", "mm/dd/yyyy")
        echo strptime("18/05/2009 16", "%m/%d/%Y %H").dt
        # check_throws ArgumentError initDateTime("18/05/2009 16", "mm/dd/yyyy hh")

    # Used "mm" for months AND minutes
    expect ValueError:
        echo strptime("18/05/2009 16:14", "%d/%m/%Y %H:%m").dt
        # check_throws ArgumentError initDateTime("18/05/2009 16:14", "mm/dd/yyyy hh:mm")
    # initDate string has different delimiters than format string
    check strptime("18:05:2009", "%d/%m/%Y").dt == initDateTime(2009, 5, 18)
    # check_throws ArgumentError initDateTime("18:05:2009", "mm/dd/yyyy")

    f = "%Y %m %d"
    check strptime("1 1 1", f).dt == initDateTime(1)
#    f = "%Y %m %d %H %M %S.%f"
#    check strptime("292277025-08-17T07:12:55.295", f) == initDateTime(292_277_025,8,17,7,12,55,296)
    expect ValueError:
        echo strptime("1 13 1", f).dt
        # check_throws ArgumentError initDate("1 13 1", f)
        echo strptime("1 1 32", f).dt
        # check_throws ArgumentError initDate("1 1 32", f)
        echo strptime(" 1 1 32", f).dt
        # check_throws ArgumentError initDate(" 1 1 32", f)
        echo strptime("# 1 1 31", f).dt
        # check_throws ArgumentError initDate("# 1 1 32", f)
        check strptime("1", f).dt == initDateTime(1)
        # check initDate("1 ", f) == initDate(1)
        check strptime("1 2", f).dt == initDateTime(1, 2)
        # check initDate("1 2", f) == initDate(1, 2)
        # can't find space delimiter (finds '/'), so fails
        echo strptime("2000/1", f).dt
        # check_throws ArgumentError initDate("2000/1", f)

    # strptime can't handle this
    #f = "%y%m%d"
    #check strptime("111", f) == initDate(1)
    # check initDate("1", f) == initDate(1)

    check strptime("20140529 123041", "%Y%m%d %H%M%S").dt == initDateTime(2014, 5, 29, 12, 30, 41)


test "julialang Issue 13":
    let t = initDateTime(1, 1, 1, 14, 51, 0, 118)
    check strptime("[14:51:00.118]", "[%H:%M:%S.%f]").dt == t
    check strptime("14:51:00.118", "%H:%M:%S.%f").dt == t
    check strptime("[14:51:00.118?", "[%H:%M:%S.%f?").dt == t
    check strptime("?14:51:00.118?", "?%H:%M:%S.%f?").dt == t
    check strptime("x14:51:00.118", "x%H:%M:%S.%f").dt == t
    check strptime("14:51:00.118]", "%H:%M:%S.%f]").dt == t

test "RFC1123Format":
    let dt = initDateTime(2014, 8, 23, 17, 22, 15)
    check strftime(dt, "$rfc1123") == "Sat, 23 Aug 2014 17:22:15 GMT"
    check strptime(strftime(dt, "$rfc1123"), "$rfc1123").dt == dt
    check strftime(dt, "%Y-%m-%dT%H:%M:%S %A") == "2014-08-23T17:22:15 Saturday"
    check strftime(dt, "%Y-%m-%dT%H:%M:%S %a") == "2014-08-23T17:22:15 Sat"
    check strftime(dt, "%Y-%m-%d %A") == "2014-08-23 Saturday"
    check strftime(dt, "%Y-%m-%d %a") == "2014-08-23 Sat"
    check strftime(dt, "%Y-%a-%m-%d") == "2014-Sat-08-23"

    check strftime(initDateTime(2014, 1, 2, 0, 0, 0, 999), "$rfc1123") == "Thu, 02 Jan 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 2, 18, 0, 0, 0, 9), "$rfc1123") == "Tue, 18 Feb 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 3, 8, 0, 0, 0, 9), "$rfc1123") == "Sat, 08 Mar 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 4, 28, 0, 0, 0, 9), "$rfc1123") == "Mon, 28 Apr 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 5, 10, 0, 0, 0, 9), "$rfc1123") == "Sat, 10 May 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 6, 4, 0, 0, 0, 9), "$rfc1123") == "Wed, 04 Jun 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 7, 13, 0, 0, 0, 9), "$rfc1123") == "Sun, 13 Jul 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 8, 17, 0, 0, 0, 9), "$rfc1123") == "Sun, 17 Aug 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 9, 20, 0, 0, 0, 9), "$rfc1123") == "Sat, 20 Sep 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 10, 31, 0, 0, 0, 9), "$rfc1123") == "Fri, 31 Oct 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 11, 2, 0, 0, 0, 9), "$rfc1123") == "Sun, 02 Nov 2014 00:00:00 GMT"
    check strftime(initDateTime(2014, 12, 5, 0, 0, 0, 9), "$rfc1123") == "Fri, 05 Dec 2014 00:00:00 GMT"

    var dt1 = initDateTime(2016, 11, 12, 7, 45, 36)
    check strptime("Sat, 12 Nov 2016 07:45:36", "$rfc1123").dt == dt1
    check strptime("Mon, 12 Nov 2016 07:45:36", "$rfc1123").dt == dt1  # Wrong day of week
    expect ValueError:
        echo strptime("Foo, 12 Nov 2016 07:45:36", "$rfc1123").dt
    # check_throws ArgumentError parse(initDate, "Foo, 12 Nov 2016 07:45:36", RFC1123Format)


test "julialang Issue 15195":
    let f = "%Y"
    check strftime(strptime("1999", f).dt, f) == "1999"
    check strftime(initDate(9), f) == "0009"
    when not defined(js):
        # we don't have enough precision on the js backend, therefore we skip this test
        # the error is relatively small: js is one year off: 252522163911148
        check strftime(Date(instant: UTD(92231826452317474)), "%Y") == "252522163911149"


# # Issue: https://github.com/quinnj/TimeZones.jl/issues/19
# let
#     const Zulu = String

#     function tryparsenext(d::initDatePart{'Z'}, str, i, len)
#         tryparsenext_word(str, i, len, min_width(d), max_width(d))
#     end

#     str = "2015-07-24T05:38:19.591Z"
#     dt = initDateTime(2015, 7, 24, 5, 38, 19, 591)
#     parsed = Any[
#         Year(2015), Month(7), Day(24),
#         Hour(5), Minute(38), Second(19), Millisecond(591)
#     ]

#     format = "yyyy-mm-ddTHH:MM:SS.sssZ"
#     escaped_format = "yyyy-mm-dd\\THH:MM:SS.sss\\Z"

#     # Typically 'Z' isn't treated as a specifier so it doesn't have to be escaped
#     check parse_components(str, initDateFormat(format)) == parsed
#     check parse_components(str, initDateFormat(escaped_format)) == parsed

#     try
#         # Make 'Z' into a specifier
#         CONVERSION_SPECIFIERS['Z'] = Zulu
#         CONVERSION_DEFAULTS[Zulu] = ""

#         check parse_components(str, initDateFormat(format)) == [parsed; Zulu("Z")]
#         check parse_components(str, initDateFormat(escaped_format)) == parsed
#     finally
#         delete!(CONVERSION_SPECIFIERS, 'Z')
#         delete!(CONVERSION_DEFAULTS, Zulu)
#     end

#     # Ensure that the default behaviour has been restored
#     check parse_components(str, initDateFormat(format)) == parsed
#     check parse_components(str, initDateFormat(escaped_format)) == parsed
# end

# # Issue 10817
# check initDate("Apr 01 2014", "uuu dd yyyy") == initDate(2014, 4, 1)
# check_throws ArgumentError initDate("Apr 01 xx 2014", "uuu dd zz yyyy")
# check_throws ArgumentError initDate("Apr 01 xx 2014", "uuu dd    yyyy")

# # Issue 21001
# for (ms, str) in zip([0, 1, 20, 300, 450, 678], ["0", "001", "02", "3", "45", "678"])
#     dt = initDateTime(2000, 1, 1, 0, 0, 0, ms)
#     check format(dt, "s") == str
#     check format(dt, "ss") == rpad(str, 2, '0')
#     check format(dt, "sss") == rpad(str, 3, '0')
#     check format(dt, "ssss") == rpad(str, 4, '0')
# end

# # Issue #21504
# check isnull(tryparse(initDate, "0-1000"))

# # Issue #22100
# checkset "parse milliseconds" begin
#     check initDateTime("2017-Mar-17 00:00:00.0000", "y-u-d H:M:S.s") == initDateTime(2017, 3, 17)
#     check parse_components(".1", initDateFormat(".s")) == [Millisecond(100)]
#     check parse_components(".12", initDateFormat(".s")) == [Millisecond(120)]
#     check parse_components(".123", initDateFormat(".s")) == [Millisecond(123)]
#     check parse_components(".1230", initDateFormat(".s")) == [Millisecond(123)]
#     check_throws InexactError parse_components(".1234", initDateFormat(".s"))

#     # Ensure that no overflow occurs when using Int32 literals: Int32(10)^10
#     check parse_components("." * rpad(999, 10, '0'), initDateFormat(".s")) == [Millisecond(999)]
# end
