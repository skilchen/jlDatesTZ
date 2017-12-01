import ../../jlDatesTZ
import unittest

test "Test conversion to and from unix":
    check unix2datetime(datetime2unix(initDateTime(2000, 1, 1))) == initDateTime(2000, 1, 1)
    check value(initDateTime(1970)) == UNIXEPOCH

    # Tests from here: https://en.wikipedia.org/wiki/Unix_time
    check $(unix2datetime(1095379198.75)) == "2004-09-16T23:59:58.750"
    check $(unix2datetime(1095379199.00)) == "2004-09-16T23:59:59.000"
    check $(unix2datetime(1095379199.25)) == "2004-09-16T23:59:59.250"
    check $(unix2datetime(1095379199.50)) == "2004-09-16T23:59:59.500"
    check $(unix2datetime(1095379199.75)) == "2004-09-16T23:59:59.750"
    check $(unix2datetime(1095379200.00)) == "2004-09-17T00:00:00.000"
    check $(unix2datetime(1095379200.25)) == "2004-09-17T00:00:00.250"
    check $(unix2datetime(1095379200.50)) == "2004-09-17T00:00:00.500"
    check $(unix2datetime(1095379200.75)) == "2004-09-17T00:00:00.750"
    check $(unix2datetime(1095379201.00)) == "2004-09-17T00:00:01.000"
    check $(unix2datetime(1095379201.25)) == "2004-09-17T00:00:01.250"
    check $(unix2datetime(915148798.75)) == "1998-12-31T23:59:58.750"
    check $(unix2datetime(915148799.00)) == "1998-12-31T23:59:59.000"
    check $(unix2datetime(915148799.25)) == "1998-12-31T23:59:59.250"
    check $(unix2datetime(915148799.50)) == "1998-12-31T23:59:59.500"
    check $(unix2datetime(915148799.75)) == "1998-12-31T23:59:59.750"
    check $(unix2datetime(915148800.00)) == "1999-01-01T00:00:00.000"
    check $(unix2datetime(915148800.25)) == "1999-01-01T00:00:00.250"
    check $(unix2datetime(915148800.50)) == "1999-01-01T00:00:00.500"
    check $(unix2datetime(915148800.75)) == "1999-01-01T00:00:00.750"
    check $(unix2datetime(915148801.00)) == "1999-01-01T00:00:01.000"
    check $(unix2datetime(915148801.25)) == "1999-01-01T00:00:01.250"

test "Test conversion to and from Rata Die":
    check toDate(rata2datetime(734869)) == initDate(2013, 1, 1)
    check datetime2rata(rata2datetime(734869)) == 734869

test "Test conversion to and from julian day number":
# Tests from here: http://mysite.verizon.net/aesir_research/date/back.htm#JDN
    check julianday2datetime(1721119.5) == initDateTime(0, 3, 1)
    check julianday2datetime(1721424.5) == initDateTime(0, 12, 31)
    check julianday2datetime(1721425.5) == initDateTime(1, 1, 1)
    check julianday2datetime(2299149.5) == initDateTime(1582, 10, 4)
    check julianday2datetime(2415020.5) == initDateTime(1900, 1, 1)
    check julianday2datetime(2415385.5) == initDateTime(1901, 1, 1)
    check julianday2datetime(2440587.5) == initDateTime(1970, 1, 1)
    check julianday2datetime(2444239.5) == initDateTime(1980, 1, 1)
    check julianday2datetime(2452695.625) == initDateTime(2003, 2, 25, 3)
    check datetime2julianday(initDateTime(2013, 12, 3, 21)) == 2456630.375

check now() is DateTime
check today() is Date


# Issue #9171, #9169
let t: seq[Period] = @[Week(2), Day(14), Hour(14 * 24), Minute(14 * 24 * 60), Second(14 * 24 * 60 * 60), Millisecond(14 * 24 * 60 * 60 * 1000)]
for i in 0..len(t)-1:
    for j in 0..len(t)-1:
        check t[i] == t[j]
    for j in i+1..high(t):
        var Pj: type(t[j])
        Pj.value = 1
        let tj1 = t[j] + Pj
        check t[i] < tj1


test "Ensure that conversion of 32-bit integers work":
    let dt = initDateTime(1915, 1, 1, 12)
    let unix = int32(datetime2unix(dt))
    let julian = int32(datetime2julianday(dt))

    check unix2datetime(float(unix)) == dt
    check julianday2datetime(float(julian)) == dt


test "Conversions to/from numbers":
    let a = initDateTime(2000)
    let b = initDate(2000)
    check value(b) == 730120
    check value(a) == 63082368000000
    check DateTime(instant: UTM(63082368000000)) == a
    check DateTime(instant: UTM(63082368000000.0)) == a
    check Date(instant: UTD(730120)) == b
    check Date(instant: UTD(730120.0)) == b
    check Date(instant: UTD(int32(730120))) == b

    let dt1 = initDateTime(2000, 1, 1, 23, 59, 59, 50)
    let t1 = toTime(dt1)
    check hour(t1) == 23
    check minute(t1) == 59
    check second(t1) == 59
    check millisecond(t1) == 50
    check microsecond(t1) == 0
    check nanosecond(t1) == 0
