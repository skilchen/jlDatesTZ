import jlDates

echo now()
echo floor(now(), 5.Minute)
echo ceil(now(), 5.Minute)
echo round(today(), 300.Day)

echo initDateTime(2017)
echo initDateTime(2001)

echo CompoundPeriod(milliseconds = Millisecond(3_500_000_000_000 - 20_000))
echo Millisecond(365.Day)

var cp = CompoundPeriod(years = Year(10)) + CompoundPeriod(months = Month(77))
echo cp
echo -cp
echo cp * 2
echo cp * -1
cp = cp + 1.Day + 49.Hour + 15.Minute + 33.Second + 1.Millisecond
echo ""
echo cp
var td = today()
echo td
echo td + cp
echo ""
var n = now()
echo n
echo n + cp
echo n - cp

echo ""
n = initDateTime(2017, 3, 31)
echo n + 1.Month
let ti0 = CompoundPeriod(months = -1.Month, hours = 2.Hour, minutes=15.Minute, seconds=10.Second, milliseconds=123.Millisecond)
var n1 = n + ti0
echo ""
echo n
echo n1
echo ti0
let ti1 = toTimeInterval(n, n1)
echo ti1
echo n + ti1, " ", n1 - ti1
let ti2 = toTimeInterval(n1, n)
echo ti2
echo n - ti2, " ", n1 + ti2
echo n - n1
echo canonicalize(CompoundPeriod(milliseconds = (n1 + 1.Month) - (n1 - 1.Month)))

echo rata2iso(datetime2rata(initDate(2021,1,3)))
echo strftime(initDateTime(2021,1,3,1,2,3,456), "%V %W $http, $wiso, $rfc3339")
echo "i2r: ", iso2rata(2017, 1, 1)
echo datetime2rata(initDate(2017, 1, 2))
echo toprev(initDate(2017,1,1), 7)
echo tonth(initDate(2017,1,1), 1, 7)
echo strptime("gugus 2017-12-31T03:04:05.987-02:31:23", "hello %Y world %m %d %H %M %S %f")
echo strptime("Jan 1 2018 GMT", "%b %d %y")
echo strptime("1. may -20000001", "%d %B %Y")
echo strptime(strftime(initDateTime(2021,1,3,1,2,3,456), "$http, $wiso, $rfc3339"), "%d %b %Y %H:%M:%S")
# for x in countUp(initDate(2017,1,31), initDate(2018)-1.Day, Day(1)):
#   echo x
# for x in countDown(initDateTime(2017,1,31), initDateTime(2017), Hour(1)):
#   echo x
# echo weekdayonorbefore(1, now())
# echo weekdayonorafter(1, now())
# echo weekdaybefore(7, initDate(2017,12,1))
# echo weekdayafter(7, initDate(2017,12,1))
# echo tonth(initDate(2017,12,25), -4, 7)
# echo nthweekday(-4, 7, initDate(2017, 12, 25))
# for y in 2018..2018:
#   echo easter(y), " ", orthodox_easter(y)
echo strptime("2017-11-24T17:45:00", "$iso")
echo strptime("2017-W52-7", "$wiso")
echo strftime(strptime("2020-W53-7", "$wiso"), "$wiso")
echo strftime(now(), "$ctime")
echo strptime(strftime(now(), "$ctime"), "$ctime")
echo strftime(now(), "$rfc850")
echo strptime(strftime(now(), "$rfc850"), "$rfc850")
echo strptime(strftime(now(), "$rfc1123"), "$rfc1123")
