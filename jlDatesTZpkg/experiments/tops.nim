import jlDates
import typetraits

echo 3.Year / 4.Year
echo fld(-5.Year, 3.Year)
echo abs(-5.Year)

echo -5.Year mod 3
echo modulo(-5.Year, 3)

echo gcd(2016.Months, 456.Months)
echo gcd(-2020.Year, 24.Years)

echo dayabbr(dayofweek(today() + 10.Years + 1.Months - 1.Days))

echo initDate("2017-11-26")
echo initDateTime("2017-11-26 00:00:02.999 +01:02")
echo initDateTime("2017-11-26T01:12-13")
echo initDateTime("2017-11-26 01:02:03.456-03:00")

echo initISOWeekDate("2019-W52-7")
echo initISOWeekDate(strftime(initDate("2019-12-31"),"$wiso"))
echo week(initDate(2020, 12,31))
echo isISOLongYear(2020)

let t = initTime(milliseconds = int(toms(4.Years)))
echo now()
echo initDateTime(2017,1,31) + t
echo t + 1.Nanosecond + 13.Hours
