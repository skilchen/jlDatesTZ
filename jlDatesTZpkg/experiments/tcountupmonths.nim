import jlDates

echo initDate(2017) + 60_000_000.Month
var i = 0
var last_x: Date
for x in countUp(initDate(2017,1,1),initDate(5002017), 1.Month):
  last_x = x
  inc(i)
echo i
echo last_x