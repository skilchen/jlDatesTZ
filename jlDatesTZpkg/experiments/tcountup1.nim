import jlDates

type PeriodKind* = enum
   pkYear, pkQuarter, pkMonth, pkWeek, pkDay,
   pkHour, pkMinute, pkSecond,
   pkMillisecond, pkMicrosecond, pkNanosecond

type
   AbstractTime = object of RootObj
#   Instant = object of AbstractTime
   Period = object of AbstractTime
     kind*: PeriodKind
     value*: int64
   UTInstant = object #of Instant
     periods: Period
   TimeType = object of AbstractTime
     instant: UTInstant
   DateTime* = object of TimeType

type dt1 = object of DateTime
  j: int64
#type dt2 = object of dt1

proc `+`*(dt: dt1, x: TMillisecond): dt1 =
  echo "do"
  result.instant.periods.value = dt.instant.periods.value + x.value

var j: dt1
j.j = 17_000_000_000

var start = initDateTime(2017,1,1,0,0,0,0)
echo repr(start)

for i in 1..60_000_000:
  #j = j + 1.Millisecond
  start = start + 1.Millisecond
echo j
echo start