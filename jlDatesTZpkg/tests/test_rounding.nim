import ../../jlDatesTZ
import unittest

test "Test conversion to and from the rounding epoch (ISO 8601 year 0000)":
    check epochdays2date(-1) == initDate(-1, 12, 31)
    check epochdays2date(0) == initDate(0, 1, 1)
    check epochdays2date(1) == initDate(0, 1, 2)
    check epochdays2date(736329) == initDate(2016, 1, 1)
    check epochms2datetime(-86400000) == initDateTime(-1, 12, 31)
    check epochms2datetime(0) == initDateTime(0, 1, 1)
    check epochms2datetime(86400000) == initDateTime(0, 1, 2)
    check epochms2datetime(int64(736329) * 86400000) == initDateTime(2016, 1, 1)
    check date2epochdays(initDate(-1, 12, 31)) == -1
    check date2epochdays(initDate(0, 1, 1)) == 0
    check date2epochdays(initDate(2016, 1, 1)) == 736329
    check datetime2epochms(initDateTime(-1, 12, 31)) == -86400000
    check datetime2epochms(initDateTime(0, 1, 1)) == 0
    check datetime2epochms(initDateTime(2016, 1, 1)) == int64(736329) * 86400000

test "Basic rounding tests":
    let dt = initDate(2016, 2, 28)    # Sunday
    check floor(dt, Year(1)) == initDate(2016)
    check floor(dt, Year(5)) == initDate(2015)
    check floor(dt, Year(10)) == initDate(2010)
    check floor(dt, Month(1)) == initDate(2016, 2)
    check floor(dt, Month(6)) == initDate(2016, 1)
    check floor(dt, Week(1)) == toprev(dt, 1)
    check ceil(dt, Year(1)) == initDate(2017)
    check ceil(dt, Year(5)) == initDate(2020)
    check ceil(dt, Month(1)) == initDate(2016, 3)
    check ceil(dt, Month(6)) == initDate(2016, 7)
    check ceil(dt, Week(1)) == tonext(dt, 1)
    check round(dt, Year(1)) == initDate(2016)
    check round(dt, Month(1)) == initDate(2016, 3)
    check round(dt, Week(1)) == initDate(2016, 2, 29)

    var dt1 = initDateTime(2016, 2, 28, 15, 10, 50, 500)
    check floor(dt1, Day(1)) == initDateTime(2016, 2, 28)
    check floor(dt1, Hour(1)) == initDateTime(2016, 2, 28, 15)
    check floor(dt1, Hour(2)) == initDateTime(2016, 2, 28, 14)
    check floor(dt1, Hour(12)) == initDateTime(2016, 2, 28, 12)
    check floor(dt1, Minute(1)) == initDateTime(2016, 2, 28, 15, 10)
    check floor(dt1, Minute(15)) == initDateTime(2016, 2, 28, 15, 0)
    check floor(dt1, Second(1)) == initDateTime(2016, 2, 28, 15, 10, 50)
    check floor(dt1, Second(30)) == initDateTime(2016, 2, 28, 15, 10, 30)
    check ceil(dt1, Day(1)) == initDateTime(2016, 2, 29)
    check ceil(dt1, Hour(1)) == initDateTime(2016, 2, 28, 16)
    check ceil(dt1, Hour(2)) == initDateTime(2016, 2, 28, 16)
    check ceil(dt1, Hour(12)) == initDateTime(2016, 2, 29, 0)
    check ceil(dt1, Minute(1)) == initDateTime(2016, 2, 28, 15, 11)
    check ceil(dt1, Minute(15)) == initDateTime(2016, 2, 28, 15, 15)
    check ceil(dt1, Second(1)) == initDateTime(2016, 2, 28, 15, 10, 51)
    check ceil(dt1, Second(30)) == initDateTime(2016, 2, 28, 15, 11, 0)
    check round(dt1, Day(1)) == initDateTime(2016, 2, 29)
    check round(dt1, Hour(1)) == initDateTime(2016, 2, 28, 15)
    check round(dt1, Hour(2)) == initDateTime(2016, 2, 28, 16)
    check round(dt1, Hour(12)) == initDateTime(2016, 2, 28, 12)
    check round(dt1, Minute(1)) == initDateTime(2016, 2, 28, 15, 11)
    check round(dt1, Minute(15)) == initDateTime(2016, 2, 28, 15, 15)
    check round(dt1, Second(1)) == initDateTime(2016, 2, 28, 15, 10, 51)
    check round(dt1, Second(30)) == initDateTime(2016, 2, 28, 15, 11, 0)

test "Rounding for dates at the rounding epoch (year 0000)":
    let dt = initDateTime(0)
    check floor(dt, Year(1)) == dt
    check floor(dt, Month(1)) == dt
    check floor(dt, Week(1)) == initDateTime(-1, 12, 27)   # Monday prior to 0000-01-01
    check floor(initDate(-1, 12, 27), Week(1)) == initDate(-1, 12, 27)
    check floor(dt, Day(1)) == dt
    check floor(dt, Hour(1)) == dt
    check floor(dt, Minute(1)) == dt
    check floor(dt, Second(1)) == dt
    check ceil(dt, Year(1)) == dt
    check ceil(dt, Month(1)) == dt
    check ceil(dt, Week(1)) == initDateTime(0, 1, 3)       # Monday following 0000-01-01
    check ceil(initDate(0, 1, 3), Week(1)) == initDate(0, 1, 3)
    check ceil(dt, Day(1)) == dt
    check ceil(dt, Hour(1)) == dt
    check ceil(dt, Minute(1)) == dt
    check ceil(dt, Second(1)) == dt

test "Test rounding for multiples of a period (easiest to test close to rounding epoch)":
    let dt = initDateTime(0, 1, 19, 19, 19, 19, 19)
    check floor(dt, Year(2)) == initDateTime(0)
    check floor(dt, Month(2)) == initDateTime(0, 1)       # Odd number; months are 1-indexed
    check floor(dt, Week(2)) == initDateTime(0, 1, 17)    # Third Monday of 0000
    check floor(dt, Day(2)) == initDateTime(0, 1, 19)     # Odd number; days are 1-indexed
    check floor(dt, Hour(2)) == initDateTime(0, 1, 19, 18)
    check floor(dt, Minute(2)) == initDateTime(0, 1, 19, 19, 18)
    check floor(dt, Second(2)) == initDateTime(0, 1, 19, 19, 19, 18)
    check ceil(dt, Year(2)) == initDateTime(2)
    check ceil(dt, Month(2)) == initDateTime(0, 3)        # Odd number; months are 1-indexed
    check ceil(dt, Week(2)) == initDateTime(0, 1, 31)     # Fifth Monday of 0000
    check ceil(dt, Day(2)) == initDateTime(0, 1, 21)      # Odd number; days are 1-indexed
    check ceil(dt, Hour(2)) == initDateTime(0, 1, 19, 20)
    check ceil(dt, Minute(2)) == initDateTime(0, 1, 19, 19, 20)
    check ceil(dt, Second(2)) == initDateTime(0, 1, 19, 19, 19, 20)

test "Test rounding for dates with negative years":
    let dt = initDateTime(-1, 12, 29, 19, 19, 19, 19)
    check floor(dt, Year(2)) == initDateTime(-2)
    check floor(dt, Month(2)) == initDateTime(-1, 11)     # Odd number; months are 1-indexed
    check floor(dt, Week(2)) == initDateTime(-1, 12, 20)  # 2 weeks prior to 0000-01-03
    check floor(dt, Day(2)) == initDateTime(-1, 12, 28)   # Even; 4 days prior to 0000-01-01
    check floor(dt, Hour(2)) == initDateTime(-1, 12, 29, 18)
    check floor(dt, Minute(2)) == initDateTime(-1, 12, 29, 19, 18)
    check floor(dt, Second(2)) == initDateTime(-1, 12, 29, 19, 19, 18)
    check ceil(dt, Year(2)) == initDateTime(0)
    check ceil(dt, Month(2)) == initDateTime(0, 1)        # Odd number; months are 1-indexed
    check ceil(dt, Week(2)) == initDateTime(0, 1, 3)      # First Monday of 0000
    check ceil(dt, Day(2)) == initDateTime(-1, 12, 30)    # Even; 2 days prior to 0000-01-01
    check ceil(dt, Hour(2)) == initDateTime(-1, 12, 29, 20)
    check ceil(dt, Minute(2)) == initDateTime(-1, 12, 29, 19, 20)
    check ceil(dt, Second(2)) == initDateTime(-1, 12, 29, 19, 19, 20)

test "Test rounding for dates that should not need rounding":
    for dt in [initDateTime(2016, 1, 1), initDateTime(-2016, 1, 1)]:
        check floor(dt, Year(1)) == dt
        check ceil(dt, Year(1)) == dt
        check floor(dt, Month(1)) == dt
        check ceil(dt, Month(1)) == dt
        check floor(dt, Day(1)) == dt
        check ceil(dt, Day(1)) == dt
        check floor(dt, Hour(1)) == dt
        check ceil(dt, Hour(1)) == dt
        check floor(dt, Minute(1)) == dt
        check ceil(dt, Minute(1)) == dt
        check floor(dt, Second(1)) == dt
        check ceil(dt, Second(1)) == dt

