import typetraits

type
  PeriodKind = enum
    pkYear, pkQuarter, pkMonth, pkWeek, pkDay, pkHour, pkMinute, pkSecond,
    pkMillisecond, pkMicrosecond, pkNanosecond

  AbstractTime = object of RootObj
  Period = object of AbstractTime
    kind: PeriodKind
    value: int64
  DatePeriod = object of Period
  TimePeriod = object of Period

  TYear = object of DatePeriod

  TMonth = object of DatePeriod
  TWeek* = object of DatePeriod
  TDay = object of DatePeriod

  THour = ref object of TimePeriod
  TMinute = object of TimePeriod
  TSecond = object of TimePeriod
  TMillisecond = object of TimePeriod
  TMicrosecond = object of TimePeriod
  TNanosecond = object of TimePeriod

type
  Instant = object of AbstractTime
  UTInstant = object of Instant
    periods: Period

type
  Calendar = object of AbstractTime
  ISOCalendar* = object of Calendar

type
  Timezone = object of RootObj
  UTC* = object of Timezone

type
  TimeType = object of AbstractTime
    instant: UTInstant
  DateTime = object of TimeType
  Date = object of TimeType
  Time = object of TimeType

type gPeriod = TYear|TMonth|TDay|THour|TMinute|TSecond|TMillisecond|TMicrosecond|TNanosecond

type pSeq[T] = object
  s: seq[T]

proc testv[T: ref Period](x: varargs[T]) =
  for x in x:
    echo name(type(x))
    case x.kind
    of pkHour:
      echo "hour: ", x.value
    of pkYear:
      echo "year: ", x.value
    of pkMinute:
      echo "minute: ", x.value
    else:
      echo "something else"

proc test[T](x: T) =
  echo repr(x)

  if x is THour:
    echo "hour: ", x.value
  elif x is TYear:
    echo "year: ", x.value
  elif x is TMinute:
    echo "minute: ", x.value
  else:
    echo "something else: ", name(type(x))

proc newHour(v: int): THour =
  result = new THour
  result.kind = pkHour
  result.value = v

var x = newHour(19)
var y = new TYear
y.value = 2
y.kind = pkYear
var z: ref TMinute = new TMinute
z.value = 3
z.kind = pkMinute
var d = DateTime()

echo x[] is Period
echo x is THour
echo x[] is TimePeriod


test(x)
test(y[])
test(z[])
#test(3)


echo name(type(x))
var p: pSeq[ref Period]
p.s = @[]
p.s.add(x)
p.s.add(y)
p.s.add(z)

for a in p.s:
  echo name(type(a))

testv(p.s[0], p.s[1], p.s[2])
