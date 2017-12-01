import ../../jlDatesTZ
import unittest

test "Time arithmetic":
  let a = initTime(23, 59, 59)
  let b = initTime(11, 59, 59)
  check CompoundPeriod(milliseconds = Millisecond(value(a - b) div 1_000_000)) == CompoundPeriod(hours = Hour(12))

test "DateTime arithmetic":
  let a = initDateTime(2013, 1, 1, 0, 0, 0, 1)
  let b = initDateTime(2013, 1, 1, 0, 0, 0, 0)
  check((a - b) == Millisecond(1))
  check((initDateTime(2013, 1, 2) - b) == Millisecond(86400000))

test "DateTime-Year arithmetic":
  var dt = initDateTime(1999, 12, 27)
  check dt + Year(1) == initDateTime(2000, 12, 27)
  check dt + Year(100) == initDateTime(2099, 12, 27)
  check dt + Year(1000) == initDateTime(2999, 12, 27)
  check dt - Year(1) == initDateTime(1998, 12, 27)
  check dt - Year(100) == initDateTime(1899, 12, 27)
  check dt - Year(1000) == initDateTime(999, 12, 27)
  dt = initDateTime(2000, 2, 29)
  check dt + Year(1) == initDateTime(2001, 2, 28)
  check dt - Year(1) == initDateTime(1999, 2, 28)
  check dt + Year(4) == initDateTime(2004, 2, 29)
  check dt - Year(4) == initDateTime(1996, 2, 29)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Year(1) == initDateTime(1973, 6, 30, 23, 59, 59)
  check dt - Year(1) == initDateTime(1971, 6, 30, 23, 59, 59)
  check dt + Year(-1) == initDateTime(1971, 6, 30, 23, 59, 59)
  check dt - Year(-1) == initDateTime(1973, 6, 30, 23, 59, 59)

test "Wrapping arithemtic for Months":
  # This ends up being trickier than expected because
  # the user might do 2014-01-01 + Month(-14)
  # monthwrap figures out the resulting month
  # when adding/subtracting months from a date
  check monthwrap(1, -14) == 11
  check monthwrap(1, -13) == 12
  check monthwrap(1, -12) == 1
  check monthwrap(1, -11) == 2
  check monthwrap(1, -10) == 3
  check monthwrap(1, -9) == 4
  check monthwrap(1, -8) == 5
  check monthwrap(1, -7) == 6
  check monthwrap(1, -6) == 7
  check monthwrap(1, -5) == 8
  check monthwrap(1, -4) == 9
  check monthwrap(1, -3) == 10
  check monthwrap(1, -2) == 11
  check monthwrap(1, -1) == 12
  check monthwrap(1, 0) == 1
  check monthwrap(1, 1) == 2
  check monthwrap(1, 2) == 3
  check monthwrap(1, 3) == 4
  check monthwrap(1, 4) == 5
  check monthwrap(1, 5) == 6
  check monthwrap(1, 6) == 7
  check monthwrap(1, 7) == 8
  check monthwrap(1, 8) == 9
  check monthwrap(1, 9) == 10
  check monthwrap(1, 10) == 11
  check monthwrap(1, 11) == 12
  check monthwrap(1, 12) == 1
  check monthwrap(1, 13) == 2
  check monthwrap(1, 24) == 1
  check monthwrap(12, -14) == 10
  check monthwrap(12, -13) == 11
  check monthwrap(12, -12) == 12
  check monthwrap(12, -11) == 1
  check monthwrap(12, -2) == 10
  check monthwrap(12, -1) == 11
  check monthwrap(12, 0) == 12
  check monthwrap(12, 1) == 1
  check monthwrap(12, 2) == 2
  check monthwrap(12, 11) == 11
  check monthwrap(12, 12) == 12
  check monthwrap(12, 13) == 1

test "yearwrap figures out the resulting year":
# when adding/subtracting months from a date
  check yearwrap(2000, 1, -3600) == 1700
  check yearwrap(2000, 1, -37) == 1996
  check yearwrap(2000, 1, -36) == 1997
  check yearwrap(2000, 1, -35) == 1997
  check yearwrap(2000, 1, -25) == 1997
  check yearwrap(2000, 1, -24) == 1998
  check yearwrap(2000, 1, -23) == 1998
  check yearwrap(2000, 1, -14) == 1998
  check yearwrap(2000, 1, -13) == 1998
  check yearwrap(2000, 1, -12) == 1999
  check yearwrap(2000, 1, -11) == 1999
  check yearwrap(2000, 1, -2) == 1999
  check yearwrap(2000, 1, -1) == 1999
  check yearwrap(2000, 1, 0) == 2000
  check yearwrap(2000, 1, 1) == 2000
  check yearwrap(2000, 1, 11) == 2000
  check yearwrap(2000, 1, 12) == 2001
  check yearwrap(2000, 1, 13) == 2001
  check yearwrap(2000, 1, 23) == 2001
  check yearwrap(2000, 1, 24) == 2002
  check yearwrap(2000, 1, 25) == 2002
  check yearwrap(2000, 1, 36) == 2003
  check yearwrap(2000, 1, 3600) == 2300
  check yearwrap(2000, 2, -2) == 1999
  check yearwrap(2000, 3, 10) == 2001
  check yearwrap(2000, 4, -4) == 1999
  check yearwrap(2000, 5, 8) == 2001
  check yearwrap(2000, 6, -18) == 1998
  check yearwrap(2000, 6, -6) == 1999
  check yearwrap(2000, 6, 6) == 2000
  check yearwrap(2000, 6, 7) == 2001
  check yearwrap(2000, 6, 19) == 2002
  check yearwrap(2000, 12, -3600) == 1700
  check yearwrap(2000, 12, -36) == 1997
  check yearwrap(2000, 12, -35) == 1998
  check yearwrap(2000, 12, -24) == 1998
  check yearwrap(2000, 12, -23) == 1999
  check yearwrap(2000, 12, -14) == 1999
  check yearwrap(2000, 12, -13) == 1999
  check yearwrap(2000, 12, -12) == 1999
  check yearwrap(2000, 12, -11) == 2000
  check yearwrap(2000, 12, -2) == 2000
  check yearwrap(2000, 12, -1) == 2000
  check yearwrap(2000, 12, 0) == 2000
  check yearwrap(2000, 12, 1) == 2001
  check yearwrap(2000, 12, 11) == 2001
  check yearwrap(2000, 12, 12) == 2001
  check yearwrap(2000, 12, 13) == 2002
  check yearwrap(2000, 12, 24) == 2002
  check yearwrap(2000, 12, 25) == 2003
  check yearwrap(2000, 12, 36) == 2003
  check yearwrap(2000, 12, 37) == 2004
  check yearwrap(2000, 12, 3600) == 2300

test "DateTime: add/subtract months":
  var dt = initDateTime(1999, 12, 27)
  check dt + Month(1) == initDateTime(2000, 1, 27)
  check dt + Month(-1) == initDateTime(1999, 11, 27)
  check dt + Month(-11) == initDateTime(1999, 1, 27)
  check dt + Month(11) == initDateTime(2000, 11, 27)
  check dt + Month(-12) == initDateTime(1998, 12, 27)
  check dt + Month(12) == initDateTime(2000, 12, 27)
  check dt + Month(13) == initDateTime(2001, 1, 27)
  check dt + Month(100) == initDateTime(2008, 4, 27)
  check dt + Month(1000) == initDateTime(2083, 4, 27)
  check dt - Month(1) == initDateTime(1999, 11, 27)
  check dt - Month(-1) == initDateTime(2000, 1, 27)
  check dt - Month(100) == initDateTime(1991, 8, 27)
  check dt - Month(1000) == initDateTime(1916, 8, 27)
  dt = initDateTime(2000, 2, 29)
  check dt + Month(1) == initDateTime(2000, 3, 29)
  check dt - Month(1) == initDateTime(2000, 1, 29)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Month(1) == initDateTime(1972, 7, 30, 23, 59, 59)
  check dt - Month(1) == initDateTime(1972, 5, 30, 23, 59, 59)
  check dt + Month(-1) == initDateTime(1972, 5, 30, 23, 59, 59)

test "DateTime: add/subtract weeks":
  var dt = initDateTime(1999, 12, 27)
  check dt + Week(1) == initDateTime(2000, 1, 3)
  check dt + Week(100) == initDateTime(2001, 11, 26)
  check dt + Week(1000) == initDateTime(2019, 2, 25)
  check dt - Week(1) == initDateTime(1999, 12, 20)
  check dt - Week(100) == initDateTime(1998, 1, 26)
  check dt - Week(1000) == initDateTime(1980, 10, 27)
  dt = initDateTime(2000, 2, 29)
  check dt + Week(1) == initDateTime(2000, 3, 7)
  check dt - Week(1) == initDateTime(2000, 2, 22)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Week(1) == initDateTime(1972, 7, 7, 23, 59, 59)
  check dt - Week(1) == initDateTime(1972, 6, 23, 23, 59, 59)
  check dt + Week(-1) == initDateTime(1972, 6, 23, 23, 59, 59)

test "DateTime: add/subtract days":
  var dt = initDateTime(1999, 12, 27)
  check dt + Day(1) == initDateTime(1999, 12, 28)
  check dt + Day(100) == initDateTime(2000, 4, 5)
  check dt + Day(1000) == initDateTime(2002, 9, 22)
  check dt - Day(1) == initDateTime(1999, 12, 26)
  check dt - Day(100) == initDateTime(1999, 9, 18)
  check dt - Day(1000) == initDateTime(1997, 4, 1)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Day(1) == initDateTime(1972, 7, 1, 23, 59, 59)
  check dt - Day(1) == initDateTime(1972, 6, 29, 23, 59, 59)
  check dt + Day(-1) == initDateTime(1972, 6, 29, 23, 59, 59)

test "DateTime: add/subtract hours":
  var dt = initDateTime(1999, 12, 27)
  check dt + Hour(1) == initDateTime(1999, 12, 27, 1)
  check dt + Hour(100) == initDateTime(1999, 12, 31, 4)
  check dt + Hour(1000) == initDateTime(2000, 2, 6, 16)
  check dt - Hour(1) == initDateTime(1999, 12, 26, 23)
  check dt - Hour(100) == initDateTime(1999, 12, 22, 20)
  check dt - Hour(1000) == initDateTime(1999, 11, 15, 8)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Hour(1) == initDateTime(1972, 7, 1, 0, 59, 59)
  check dt - Hour(1) == initDateTime(1972, 6, 30, 22, 59, 59)
  check dt + Hour(-1) == initDateTime(1972, 6, 30, 22, 59, 59)

test "DateTime: add/subtract minutes":
  var dt = initDateTime(1999, 12, 27)
  check dt + Minute(1) == initDateTime(1999, 12, 27, 0, 1)
  check dt + Minute(100) == initDateTime(1999, 12, 27, 1, 40)
  check dt + Minute(1000) == initDateTime(1999, 12, 27, 16, 40)
  check dt - Minute(1) == initDateTime(1999, 12, 26, 23, 59)
  check dt - Minute(100) == initDateTime(1999, 12, 26, 22, 20)
  check dt - Minute(1000) == initDateTime(1999, 12, 26, 7, 20)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Minute(1) == initDateTime(1972, 7, 1, 0, 0, 59)
  check dt - Minute(1) == initDateTime(1972, 6, 30, 23, 58, 59)
  check dt + Minute(-1) == initDateTime(1972, 6, 30, 23, 58, 59)

test "DateTime: add/subtract seconds":
  var dt = initDateTime(1999, 12, 27)
  check dt + Second(1) == initDateTime(1999, 12, 27, 0, 0, 1)
  check dt + Second(100) == initDateTime(1999, 12, 27, 0, 1, 40)
  check dt + Second(1000) == initDateTime(1999, 12, 27, 0, 16, 40)
  check dt - Second(1) == initDateTime(1999, 12, 26, 23, 59, 59)
  check dt - Second(100) == initDateTime(1999, 12, 26, 23, 58, 20)
  check dt - Second(1000) == initDateTime(1999, 12, 26, 23, 43, 20)

test "DateTime: add/subtract milliseconds":
  var dt = initDateTime(1999, 12, 27)
  check dt + Millisecond(1) == initDateTime(1999, 12, 27, 0, 0, 0, 1)
  check dt + Millisecond(100) == initDateTime(1999, 12, 27, 0, 0, 0, 100)
  check dt + Millisecond(1000) == initDateTime(1999, 12, 27, 0, 0, 1)
  check dt - Millisecond(1) == initDateTime(1999, 12, 26, 23, 59, 59, 999)
  check dt - Millisecond(100) == initDateTime(1999, 12, 26, 23, 59, 59, 900)
  check dt - Millisecond(1000) == initDateTime(1999, 12, 26, 23, 59, 59)
  dt = initDateTime(1972, 6, 30, 23, 59, 59)
  check dt + Millisecond(1) == initDateTime(1972, 6, 30, 23, 59, 59, 1)
  check dt - Millisecond(1) == initDateTime(1972, 6, 30, 23, 59, 58, 999)
  check dt + Millisecond(-1) == initDateTime(1972, 6, 30, 23, 59, 58, 999)

test "Date: add/subtract years":
  var dt = initDate(1999, 12, 27)
  check dt + Year(1) == initDate(2000, 12, 27)
  check dt + Year(100) == initDate(2099, 12, 27)
  check dt + Year(1000) == initDate(2999, 12, 27)
  check dt - Year(1) == initDate(1998, 12, 27)
  check dt - Year(100) == initDate(1899, 12, 27)
  check dt - Year(1000) == initDate(999, 12, 27)
  dt = initDate(2000, 2, 29)
  check dt + Year(1) == initDate(2001, 2, 28)
  check dt - Year(1) == initDate(1999, 2, 28)
  check dt + Year(4) == initDate(2004, 2, 29)
  check dt - Year(4) == initDate(1996, 2, 29)

test "Date: add/subtract months":
  var dt = initDate(1999, 12, 27)
  check dt + Month(1) == initDate(2000, 1, 27)
  check dt + Month(100) == initDate(2008, 4, 27)
  check dt + Month(1000) == initDate(2083, 4, 27)
  check dt - Month(1) == initDate(1999, 11, 27)
  check dt - Month(100) == initDate(1991, 8, 27)
  check dt - Month(1000) == initDate(1916, 8, 27)
  dt = initDate(2000, 2, 29)
  check dt + Month(1) == initDate(2000, 3, 29)
  check dt - Month(1) == initDate(2000, 1, 29)

test "Date: add/subtract weeks":
  var dt = initDate(1999, 12, 27)
  check dt + Week(1) == initDate(2000, 1, 3)
  check dt + Week(100) == initDate(2001, 11, 26)
  check dt + Week(1000) == initDate(2019, 2, 25)
  check dt - Week(1) == initDate(1999, 12, 20)
  check dt - Week(100) == initDate(1998, 1, 26)
  check dt - Week(1000) == initDate(1980, 10, 27)
  dt = initDate(2000, 2, 29)
  check dt + Week(1) == initDate(2000, 3, 7)
  check dt - Week(1) == initDate(2000, 2, 22)

test "initDate: add/subtract days":
  var dt = initDate(1999, 12, 27)
  check dt + Day(1) == initDate(1999, 12, 28)
  check dt + Day(100) == initDate(2000, 4, 5)
  check dt + Day(1000) == initDate(2002, 9, 22)
  check dt - Day(1) == initDate(1999, 12, 26)
  check dt - Day(100) == initDate(1999, 9, 18)
  check dt - Day(1000) == initDate(1997, 4, 1)

test "Test Time-TimePeriod arithmetic":
  var t = initTime(0)
  check t + Hour(1) == initTime(1)
  check t - Hour(1) == initTime(-1)
  check t - Nanosecond(1) == initTime(-1, 59, 59, 999, 999, 999)
  check t + Nanosecond(-1) == initTime(-1, 59, 59, 999, 999, 999)
  check t + Hour(24) == initTime(24)
  check t + Nanosecond(86400000000000) == initTime(24)
  check t - Nanosecond(86400000000000) == initTime(-24)
  check t + Minute(1) == initTime(0, 1)
  check t + Second(1) == initTime(0, 0, 1)
  check t + Millisecond(1) == initTime(0, 0, 0, 1)
  check t + Microsecond(1) == initTime(0, 0, 0, 0, 1)


suite """Month arithmetic minimizes "edit distance", or number of changes
needed to get a correct answer
This approach results in a few cases of non-associativity""":
  test "non-associativity in month arithmetic":
    var a = initDate(2012, 1, 29)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 1, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 2, 29)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 3, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 4, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 5, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 6, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 8, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 9, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 10, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)
    a = initDate(2012, 11, 30)
    check (a + Day(1)) + Month(1) != (a + Month(1)) + Day(1)


test "plus one year":
  var dt = initDateTime(2000, 1, 1, 12, 30, 45, 500)
  let dt2 = dt + Year(1)
  check year(dt2) == 2001
  check month(dt2) == 1
  check day(dt2) == 1
  check hour(dt2) == 12
  check minute(dt2) == 30
  check second(dt2) == 45
  check millisecond(dt2) == 500

