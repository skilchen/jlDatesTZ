import ../../jlDatesTZ
import unittest


let warsaw = initTZInfo("Europe/Warsaw", tzOlson)
let zdt = initZonedDateTime(initDateTime(2014,10,15,23,59,58,57), warsaw)

test "Basic truncation":
  check trunc(zdt, TYear) == initZonedDateTime(initDateTime(2014), warsaw)
  check trunc(zdt, TMonth) == initZonedDateTime(initDateTime(2014,10), warsaw)
  check trunc(zdt, TDay) == initZonedDateTime(initDateTime(2014,10,15), warsaw)
  check trunc(zdt, THour) == initZonedDateTime(initDateTime(2014,10,15,23), warsaw)
  check trunc(zdt, TMinute) == initZonedDateTime(initDateTime(2014,10,15,23,59), warsaw)
  check trunc(zdt, TSecond) == initZonedDateTime(initDateTime(2014,10,15,23,59,58), warsaw)
  check trunc(zdt, TMillisecond) == zdt

test "Ambiguous hour truncation":
  let dt = initDateTime(2014,10,26,2)
  check initZonedDateTime(dt, warsaw, prefer_dst=true) != initZonedDateTime(dt, warsaw, prefer_dst=false)
  check trunc(initZonedDateTime(dt + Minute(59), warsaw, prefer_dst=true), THour) == initZonedDateTime(dt, warsaw, prefer_dst=true)
  check trunc(initZonedDateTime(dt + Minute(59), warsaw, prefer_dst=false), THour) == initZonedDateTime(dt, warsaw, prefer_dst=false)

test "Sub-hourly offsets (Issue #33)":
  let st_johns = initTZInfo("America/St_Johns", tzOlson)   # UTC-3:30 or UTC-2:30
  let zdt = initZonedDateTime(initDateTime(2016,8,18,17,57,56,513), st_johns)
  check trunc(zdt, THour) == initZonedDateTime(initDateTime(2016,8,18,17), st_johns)

test "Adjuster functions":
  let zdt = initZonedDateTime(initDateTime(2013,9,9), warsaw) # Monday

  check firstdayofweek(zdt) == initZonedDateTime(initDateTime(2013,9,9), warsaw)
  check lastdayofweek(zdt) == initZonedDateTime(initDateTime(2013,9,15), warsaw)
  check firstdayofmonth(zdt) == initZonedDateTime(initDateTime(2013,9,1), warsaw)
  check lastdayofmonth(zdt) == initZonedDateTime(initDateTime(2013,9,30), warsaw)
  check firstdayofyear(zdt) == initZonedDateTime(initDateTime(2013,1,1), warsaw)
  check lastdayofyear(zdt) == initZonedDateTime(initDateTime(2013,12,31), warsaw)
  check firstdayofquarter(zdt) == initZonedDateTime(initDateTime(2013,7,1), warsaw)
  check lastdayofquarter(zdt) == initZonedDateTime(initDateTime(2013,9,30), warsaw)


test "TODO: Should be in Dates.":
  check lastdayofyear(initDateTime(2013,9,9)) == initDateTime(2013,12,31)
