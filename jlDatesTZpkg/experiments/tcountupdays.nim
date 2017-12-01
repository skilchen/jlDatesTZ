import jlDates

echo initDate(2017) + 60_000_000.Month
var i = 0
var last_x: DateTime
for x in countUp(initDateTime(2017,1,1),initDateTime(166291,6,4), 1.Day):
  last_x = x
  inc(i)
echo i
echo last_x