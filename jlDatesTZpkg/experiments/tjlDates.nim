import strutils
import jlDates

when isMainModule:
  let dt = initDateTime(d = Day(21), y = Year(2017), m = Month(11), h = Hour(15), mi=Minute(59),
                        s = Second(34), ms = Millisecond(999))
  echo dt
  echo yearmonthday(dt)
  echo yearmonth(dt)
  echo month(dt)
  echo monthday(dt)
  echo day(dt)
  echo week(dt)
  echo hour(dt)
  echo minute(dt)
  echo second(dt)
  echo millisecond(dt)

  echo ""
  let d1 = initDate(2017, 2, 28)
  echo d1
  echo year(d1)
  echo month(d1)
  echo day(d1)

  echo ""
  echo yearmonthday(-306)
  echo yearmonth(-306)
  echo monthday(-306)
  echo yearmonthday(-305)
  echo yearmonthday(-2)
  echo year(-1)
  echo yearmonthday(730120)
  echo totaldays(0, 1, 1)

  var
    ffrom = -10000'i64
    to = 10000'i64
    test_day = totaldays(ffrom, 1, 1)
    c = 0
  for y in ffrom..to:
    for m in 1'i64..12'i64:
      for d in 1..daysinmonth(y, m):
        let days = totaldays(y, m, d)
        doAssert days == test_day
        doAssert((y, m, d) == yearmonthday(days))
        test_day += 1
        inc(c)
  echo "c: ", c

  c = 0
  var y = 2017
  for m in 1'i64..12'i64:
    for d in 1..daysinmonth(y, m):
      for h in 0..23:
        for mi in 0..59:
          let dt2 = initDateTime(y, m, d, h, mi)
          doassert y == year(dt2)
          doassert m == month(dt2)
          doassert d == day(dt2)
          doassert d == dayofmonth(dt2)
          doassert h == hour(dt2)
          doassert mi == minute(dt2)
          doassert((m, d) == monthday(dt2))
          inc(c)
  echo "c: ", c

  c = 0
  var mi = 0
  for y in [-2013, -1, 0, 1, 2013]:
    for m in [1, 6, 12]:
      for d in [1'i64, 15'i64, daysinmonth(y, m)]:
        for h in [0, 12, 23]:
          for s in 0..59:
            for ms in [0, 1, 500, 999]:
              let dt2 = initDateTime(y, m, d, h, mi, s, ms)
              doassert y == year(dt2)
              doassert m == month(dt2)
              doassert d == day(dt2)
              doassert h == hour(dt2)
              doassert s == second(dt2)
              doassert ms == millisecond(dt2)
              inc(c)
  echo "c: ", c

  c = 0
  for y in 0..2100:
    for m in 1..12:
      for d in 1..daysinmonth(y, m):
        let d2 = initDate(y, m, d)
        doassert y == year(d2)
        doassert m == month(d2)
        doassert d == day(d2)
        inc(c)
  echo "c: ", c

  c = 0
  for h in [0, 11, 12, 23]:
    for m in [0, 59]:
      for s in [0, 59]:
        for ms in [0, 1, 500, 999]:
          for us in [0, 1, 500, 999]:
            for ns in [0, 1, 500, 999]:
              let t2 = initTime(h, m, s, ms, us, ns)
              doassert h == hour(t2)
              doassert m == minute(t2)
              doassert s == second(t2)
              doassert ms == millisecond(t2)
              if us != microsecond(t2):
                echo "t2: ", t2, " us: ", us, " microsecond(t2): ", microsecond(t2), " ", nanosecond(t2)
              doassert us == microsecond(t2)
              doassert ns == nanosecond(t2)
              inc(c)
  echo "c: ", c

  doassert week(initDate(2005, 1, 1)) == 53
  doassert week(initDate(2005, 1, 2)) == 53
  doassert week(initDate(2005, 12, 31)) == 52
  doassert week(initDate(2007, 1, 1)) == 1
  doassert week(initDate(2008, 1, 1)) == 1
  doassert week(initDate(2008, 12, 28)) == 52
  doassert week(initDate(2008, 12, 29)) == 1
  doassert week(initDate(2008, 12, 30)) == 1
  doassert week(initDate(2008, 12, 31)) == 1
  doassert week(initDate(2009, 1, 1)) == 1
  doassert week(initDate(2009, 12, 31)) == 53
  doassert week(initDate(2010, 1, 1)) == 53
  doassert week(initDate(2010, 1, 2)) == 53
  doassert week(initDate(2010, 1, 3)) == 53
  doassert week(initDate(2010, 1, 4)) == 1


  let d3 = initDate(2017,1,2)

  for i in 1..53:
    let tmp = d3 + Week(i)
    echo tmp, " ", dayname(dayofweek(tmp)), " ", monthname(tmp)

  echo ""
  echo "adding months"
  let dt3 = initDateTime(1900, 12, 31)
  echo dt3
  echo "-----"
  for i in 1..48:
    let tmp = dt3 + Month(i)
    #Hour(i) + Minute(i) + Second(i) + Millisecond(i) + Month(i) + Day(i) + Year(i)
    echo tmp, " ", dayabbr(dayofweek(tmp)), " ", monthabbr(tmp)

  echo datetime2unix(unix2datetime(0.0))
  echo "epochTime: ", epochTime()
  for i in 1..1:
    echo "now: ", now()
    when not defined(js):
      sleep(10)
  echo "today: ", today()
  echo "time: ", toTime(now())
  echo "ordinal: ", datetime2rata(now())
  echo "toDate: ", toDate(TDay(value: datetime2rata(now())))
  echo "toDay: ", toDay(now())
  echo "toDay: ", toDay(today())
  let now1 = now()
  #sleep(100)
  let now2 = now()
  echo now2 - now1
  echo "between now and 1970: ", initDate(2017,11,21) - initDate(1970 )

  echo ""
  echo Year(1) + Year(1) - Year(3)
  echo `+`(Day(100), Day(1))
  echo Day(100) - Day(200)
  echo Day(100) == Day(101)
  echo trunc(today(), TYear)
  echo trunc(now(), TMillisecond)
  echo trunc(now(), TSecond)
  echo trunc(now(), TMinute)
  echo trunc(now(), THour)
  echo trunc(now(), TDay)
  echo trunc(now(), TMonth)
  echo trunc(now(), TYear)
  echo ""
  echo firstdayofweek(now())
  echo firstdayofmonth(now())
  echo firstdayofquarter(now())
  echo firstdayofyear(now())
  echo ""
  echo lastdayofweek(now())
  echo lastdayofmonth(now())
  echo lastdayofquarter(now())
  echo lastdayofyear(now())
  echo ""
  proc thanksgiving(dt: DateTime): bool =
    result = month(dt) == 11 and dayofweek(dt) == 4 and dayofweekofmonth(dt) == 4

  var adj1 = now()
  for i in 0..20:
    adj1 = adjust(thanksgiving, adj1, Day(1), 1_000_000_000)
    echo adj1
    adj1 = adj1 + 1.Day

  echo "next Monday: ", tonext(today(), 1)
  echo "last Monday: ", toprev(today(), 1)
  echo "next Monday: ", tonext(now(), 1)
  echo("last Monday: ", toprev(now(), 1))

  echo "next time a month ends with a sunday"
  echo tonext(proc(x:Date):bool = dayofmonth(x) == dayofmonth(lastdayofmonth(x)) and dayofweek(x) == 7,
       start = today() + 2.Month, same = false)
  echo "previous time a month ended with a sunday"
  echo toprev(proc(x:Date):bool = dayofmonth(x) == dayofmonth(lastdayofmonth(x)) and dayofweek(x) == 7,
       start = today() - 1.Year, same = false)

  echo ""
  echo "first and last Monday in year for the next 2 years"
  var start = firstdayofyear(now())
  for i in 1..2:
    let firstmonday = tonext(start + i.Year, 1, same=true)
    let lastmonday = toprev(start + i.Year + 1.Year, 1)
    let weeks = Week((lastmonday - firstmonday).value div (7 * 86400000))
    echo firstmonday, " ", week(firstmonday), " ", lastmonday, " ", intToStr(week(lastmonday).int, 2), " ", firstmonday + weeks, " ", lastmonday - weeks

  echo ""
  echo "first and last Monday in month for the next 24 months"
  var startd = firstdayofmonth(today())
  for i in 1..24:
    let firstmonday = tofirst(startd + i.Month, dow = 1, period = TMonth)
    let lastmonday = tolast(startd + i.Month, dow = 1, period = TMonth)
    echo firstmonday, " ", lastmonday

echo ""
echo "julian dates"
echo datetime2julian(now())