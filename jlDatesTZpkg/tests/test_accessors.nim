import ../../jlDatesTZ
import unittest

# yearmonthday is the opposite of totaldays
test "taking Rata Die Day # and returning proleptic Gregorian date":
    check yearmonthday(-306) == (0, 2, 29)
    check yearmonth(-306) == (0, 2)
    check monthday(-306) == (2, 29)
    check yearmonthday(-305) == (0, 3, 1)
    check yearmonth(-305) == (0, 3)
    check monthday(-305) == (3, 1)
    check yearmonthday(-2) == (0, 12, 29)
    check yearmonth(-2) == (0, 12)
    check monthday(-2) == (12, 29)
    check yearmonthday(-1) == (0, 12, 30)
    check yearmonth(-1) == (0, 12)
    check monthday(-1) == (12, 30)
    check yearmonthday(0) == (0, 12, 31)
    check yearmonth(-0) == (0, 12)
    check monthday(-0) == (12, 31)
    check yearmonthday(1) == (1, 1, 1)
    check yearmonth(1) == (1, 1)
    check monthday(1) == (1, 1)
    # year, month, and day return the indivial components
    # of yearmonthday, avoiding additional calculations when possible
    check year(-1) == 0
    check month(-1) == 12
    check day(-1) == 30
    check year(0) == 0
    check month(0) == 12
    check day(0) == 31
    check year(1) == 1
    check month(1) == 1
    check day(1) == 1
    check yearmonthday(730120) == (2000, 1, 1)
    check year(730120) == 2000
    check month(730120) == 1
    check day(730120) == 1

test """Test totaldays and yearmonthday from January 1st of "from" to December 31st of "to"""":
    # test_dates(-10000, 10000) takes about 15 seconds
    # test_dates(year(typemin(Date)), year(typemax(Date))) is full range
    # and would take.......a really long time
    let
        from_d = 0
        to_d = 2100
    var test_day = totaldays(from_d, 1, 1)
    for y in from_d..to_d:
        for m in 1..12:
            for d in 1..daysinmonth(y, m):
                let days = totaldays(y, m, d)
                check days == test_day
                check (y, m, d) == yearmonthday(days)
                test_day += 1


test "Test year, month, day, hour, minute":
    let y = 0
    for m in 1..12:
        for d in 1..daysinmonth(y, m):
            for h in 0..23:
                for mi in 0..59:
                    let dt = initDateTime(y, m, d, h, mi)
                    check y == year(dt)
                    check m == month(dt)
                    check d == day(dt)
                    check d == dayofmonth(dt)
                    check h == hour(dt)
                    check mi == minute(dt)
                    check (m, d) == monthday(dt)

test "Test second, millisecond":
    let mi = 0
    for y in [-2013, -1, 0, 1, 2013]:
        for m in [1, 6, 12]:
            for d in [1, 15, daysinmonth(y, m)]:
                for h in [0, 12, 23]:
                    for s in 0..59:
                        for ms in [0, 1, 500, 999]:
                            let dt = initDateTime(y, m, d, h, mi, s, ms)
                            check y == year(dt)
                            check m == month(dt)
                            check d == day(dt)
                            check h == hour(dt)
                            check s == second(dt)
                            check ms == millisecond(dt)

test "Check year, month, day":
    for y in 0..2100:
        for m in 1..12:
            for d in 1..daysinmonth(y, m):
                let dt = initDate(y, m, d)
                check y == year(dt)
                check m == month(dt)
                check d == day(dt)

test "test hour, minute, second":
  for h in [0, 23]:
    for mi in [0, 59]:
      for s in [0, 59]:
        for ms in [0, 1, 500, 999]:
          for us in [0, 1, 500, 999]:
            for ns in [0, 1, 500, 999]:
              let t = initTime(h, mi, s, ms, us, ns)
              check h == hour(t)
              check mi == minute(t)
              check s == second(t)
              check ms == millisecond(t)
              check us == microsecond(t)
              check ns == nanosecond(t)

test "test week function":
    # Tests from https://en.wikipedia.org/wiki/ISO_week_date
    check week(initDate(2005, 1, 1)) == 53
    check week(initDate(2005, 1, 2)) == 53
    check week(initDate(2005, 12, 31)) == 52
    check week(initDate(2007, 1, 1)) == 1
    check week(initDate(2007, 12, 30)) == 52
    check week(initDate(2007, 12, 31)) == 1
    check week(initDate(2008, 1, 1)) == 1
    check week(initDate(2008, 12, 28)) == 52
    check week(initDate(2008, 12, 29)) == 1
    check week(initDate(2008, 12, 30)) == 1
    check week(initDate(2008, 12, 31)) == 1
    check week(initDate(2009, 1, 1)) == 1
    check week(initDate(2009, 12, 31)) == 53
    check week(initDate(2010, 1, 1)) == 53
    check week(initDate(2010, 1, 2)) == 53
    check week(initDate(2010, 1, 2)) == 53
    # Tests from http://www.epochconverter.com/Date-and-time/weeknumbers-by-year.php?year=1999
    var dt = initDateTime(1999, 12, 27)
    var dt1 = initDate(1999, 12, 27)
    var checkw = [52, 52, 52, 52, 52, 52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]
    for i in 0..20:
        check week(dt) == checkw[i]
        check week(dt1) == checkw[i]
        dt = dt + Day(1)
        dt1 = dt1 + Day(1)

    # Tests from http://www.epochconverter.com/initDate-and-time/weeknumbers-by-year.php?year=2000
    dt = initDateTime(2000, 12, 25)
    dt1 = initDate(2000, 12, 25)
    for i in 0..20:
        check week(dt) == checkw[i]
        check week(dt1) == checkw[i]
        dt = dt + Day(1)
        dt1 = dt1 + Day(1)

    # Test from http://www.epochconverter.com/initDate-and-time/weeknumbers-by-year.php?year=2030
    dt = initDateTime(2030, 12, 23)
    dt1 = initDate(2030, 12, 23)
    for i in 0..20:
        check week(dt) == checkw[i]
        check week(dt1) == checkw[i]
        dt = dt + Day(1)
        dt1 = dt1 + Day(1)

    # Tests from http://www.epochconverter.com/initDate-and-time/weeknumbers-by-year.php?year=2004
    dt = initDateTime(2004, 12, 20)
    dt1 = initDate(2004, 12, 20)
    checkw = [52, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53, 53, 53, 1, 1, 1, 1, 1, 1, 1]
    for i in 0..20:
        check week(dt) == checkw[i]
        check week(dt1) == checkw[i]
        dt = dt + Day(1)
        dt1 = dt1 + Day(1)


