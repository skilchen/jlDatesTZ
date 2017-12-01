import jlDates
import future

var start = initDate(2014)
var stop = initDate(2015)
proc check(dt: Date): bool =
  result = dayofweek(dt) == 7 and
           dayofweekofmonth(dt) == daysofweekinmonth(dt)
for x in recur(start, stop, 1.Day, check):
  echo x

for x in recur(toDateTime(start), toDateTime(stop), 1.Millisecond, proc (d: DateTime): bool =
  dayofweek(d) == 7 and
    hour(d) == 9 and
    dayofweekofmonth(d) == daysofweekinmonth(d) and
    week(d) mod 2 == 0):
  echo x, " ", dayname(dayofweek(x)), " ", week(x)