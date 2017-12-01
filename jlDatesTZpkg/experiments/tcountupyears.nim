import jlDates

echo 3.Year / 4.Year
echo fld(-5.Year, 3.Year)
echo abs(-5.Year)

echo initDateTime(2017) + 60_000_000.Year
var i = 0
var last_x: DateTime
for x in countUp(initDateTime(2017,1,1),initDateTime(60002017), 1.Year):
  last_x = x
  inc(i)
echo i
echo last_x