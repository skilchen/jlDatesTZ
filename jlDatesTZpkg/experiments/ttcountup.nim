import times

var i = 0
var start = initDateTime(year = 2017, month=Month(1),monthday = 1, hour = 0, minute = 0, second = 0)
var stop = initDateTime(year = 2017, month=Month(1),monthday = 1, hour = 0, minute = 0, second = 0)
for x in 0..60_000_000:
  stop = start + x.seconds
  inc(i)
echo i