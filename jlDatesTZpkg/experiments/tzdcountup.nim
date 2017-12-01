import ../ZonedDateTime/ZonedDateTime

var tz = initTZInfo("UTC0", tzPosix)
var i = 0
var last_x: ZonedDateTime
for x in countUp(initZonedDateTime(2017,1,1, tzinfo=tz),
                 initZonedDateTime(2017,1,1,16,40,0, tzinfo=tz), 1000.microseconds):
  last_x = x
  inc(i)
echo i
echo last_x