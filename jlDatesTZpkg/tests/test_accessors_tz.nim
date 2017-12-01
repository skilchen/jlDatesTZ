import ../../jlDatesTZ
import unittest

#let warsaw = getTZInfo("Europe/Warsaw", tzOlson)
let fixed = getTZInfo("CET1CEST2", tzPosix)
let zdt = initZonedDateTime(initDateTime(2014,6,12,23,59,58,57), fixed)

test "ZonedDateTime accessors":
  check localtime(zdt) == initDateTime(2014,6,12,23,59,58,57)
  check utc(zdt) == initDateTime(2014,6,13,0,59,58,57)

  check days(zdt) == 735396
  check hour(zdt) == 23
  check minute(zdt) == 59
  check second(zdt) == 58
  check millisecond(zdt) == 57

test "Make sure that Dates accessors work with ZonedDateTime.":
  check year(zdt) == 2014
  check month(zdt) == 6
  check week(zdt) == 24
  check day(zdt) == 12
  check dayofmonth(zdt) == 12
  check yearmonth(zdt) == (2014, 6)
  check monthday(zdt) == (6, 12)
  check yearmonthday(zdt) == (2014, 6, 12)

