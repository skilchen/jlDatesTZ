import jlDates

echo initDateTime(2017) + 60_000_000.Year
var i = 0
var last_x: DateTime
for x in countUp(initDateTime(2017,1,1),initDateTime(8861,10,8), 1.Hour):
  last_x = x
  inc(i)
echo i
echo last_x