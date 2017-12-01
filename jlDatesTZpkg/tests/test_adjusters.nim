import ../../jlDatesTZ
import unittest
import future

test "trunc":
    var d = initDate(2012, 12, 21)
    check trunc(d, TYear) == initDate(2012)
    check trunc(d, TMonth) == initDate(2012, 12)
    check trunc(d, TDay) == initDate(2012, 12, 21)
    var dt = initDateTime(2012, 12, 21, 16, 30, 20, 200)
    check trunc(dt, TYear) == initDateTime(2012)
    check trunc(dt, TMonth) == initDateTime(2012, 12)
    check trunc(dt, TDay) == initDateTime(2012, 12, 21)
    check trunc(dt, THour) == initDateTime(2012, 12, 21, 16)
    check trunc(dt, TMinute) == initDateTime(2012, 12, 21, 16, 30)
    check trunc(dt, TSecond) == initDateTime(2012, 12, 21, 16, 30, 20)
    check trunc(dt, TMillisecond) == initDateTime(2012, 12, 21, 16, 30, 20, 200)
    var t = initTime(1, 2, 3, 4, 5, 6)
    check trunc(t, THour) == initTime(1)
    check trunc(t, TMinute) == initTime(1, 2)
    check trunc(t, TSecond) == initTime(1, 2, 3)
    check trunc(t, TMillisecond) == initTime(1, 2, 3, 4)
    check trunc(t, TMicrosecond) == initTime(1, 2, 3, 4, 5)
    check trunc(t, TNanosecond) == initTime(1, 2, 3, 4, 5, 6)

let Jan = initDateTime(2013, 1, 1) #Tuesday
let Feb = initDateTime(2013, 2, 2) #Saturday
let Mar = initDateTime(2013, 3, 3) #Sunday
let Apr = initDateTime(2013, 4, 4) #Thursday
let May = initDateTime(2013, 5, 5) #Sunday
let Jun = initDateTime(2013, 6, 7) #Friday
let Jul = initDateTime(2013, 7, 7) #Sunday
let Aug = initDateTime(2013, 8, 8) #Thursday
let Sep = initDateTime(2013, 9, 9) #Monday
let Oct = initDateTime(2013, 10, 10) #Thursday
let Nov = initDateTime(2013, 11, 11) #Monday
let Dec = initDateTime(2013, 12, 11) #Wednesday

test "first/last day of month":
    check lastdayofmonth(Jan) == initDateTime(2013, 1, 31)
    check lastdayofmonth(Feb) == initDateTime(2013, 2, 28)
    check lastdayofmonth(Mar) == initDateTime(2013, 3, 31)
    check lastdayofmonth(Apr) == initDateTime(2013, 4, 30)
    check lastdayofmonth(May) == initDateTime(2013, 5, 31)
    check lastdayofmonth(Jun) == initDateTime(2013, 6, 30)
    check lastdayofmonth(Jul) == initDateTime(2013, 7, 31)
    check lastdayofmonth(Aug) == initDateTime(2013, 8, 31)
    check lastdayofmonth(Sep) == initDateTime(2013, 9, 30)
    check lastdayofmonth(Oct) == initDateTime(2013, 10, 31)
    check lastdayofmonth(Nov) == initDateTime(2013, 11, 30)
    check lastdayofmonth(Dec) == initDateTime(2013, 12, 31)

    check lastdayofmonth(toDate(Jan)) == initDate(2013, 1, 31)
    check lastdayofmonth(toDate(Feb)) == initDate(2013, 2, 28)
    check lastdayofmonth(toDate(Mar)) == initDate(2013, 3, 31)
    check lastdayofmonth(toDate(Apr)) == initDate(2013, 4, 30)
    check lastdayofmonth(toDate(May)) == initDate(2013, 5, 31)
    check lastdayofmonth(toDate(Jun)) == initDate(2013, 6, 30)
    check lastdayofmonth(toDate(Jul)) == initDate(2013, 7, 31)
    check lastdayofmonth(toDate(Aug)) == initDate(2013, 8, 31)
    check lastdayofmonth(toDate(Sep)) == initDate(2013, 9, 30)
    check lastdayofmonth(toDate(Oct)) == initDate(2013, 10, 31)
    check lastdayofmonth(toDate(Nov)) == initDate(2013, 11, 30)
    check lastdayofmonth(toDate(Dec)) == initDate(2013, 12, 31)

    check firstdayofmonth(Jan) == initDateTime(2013, 1, 1)
    check firstdayofmonth(Feb) == initDateTime(2013, 2, 1)
    check firstdayofmonth(Mar) == initDateTime(2013, 3, 1)
    check firstdayofmonth(Apr) == initDateTime(2013, 4, 1)
    check firstdayofmonth(May) == initDateTime(2013, 5, 1)
    check firstdayofmonth(Jun) == initDateTime(2013, 6, 1)
    check firstdayofmonth(Jul) == initDateTime(2013, 7, 1)
    check firstdayofmonth(Aug) == initDateTime(2013, 8, 1)
    check firstdayofmonth(Sep) == initDateTime(2013, 9, 1)
    check firstdayofmonth(Oct) == initDateTime(2013, 10, 1)
    check firstdayofmonth(Nov) == initDateTime(2013, 11, 1)
    check firstdayofmonth(Dec) == initDateTime(2013, 12, 1)

    check firstdayofmonth(toDate(Jan)) == initDate(2013, 1, 1)
    check firstdayofmonth(toDate(Feb)) == initDate(2013, 2, 1)
    check firstdayofmonth(toDate(Mar)) == initDate(2013, 3, 1)
    check firstdayofmonth(toDate(Apr)) == initDate(2013, 4, 1)
    check firstdayofmonth(toDate(May)) == initDate(2013, 5, 1)
    check firstdayofmonth(toDate(Jun)) == initDate(2013, 6, 1)
    check firstdayofmonth(toDate(Jul)) == initDate(2013, 7, 1)
    check firstdayofmonth(toDate(Aug)) == initDate(2013, 8, 1)
    check firstdayofmonth(toDate(Sep)) == initDate(2013, 9, 1)
    check firstdayofmonth(toDate(Oct)) == initDate(2013, 10, 1)
    check firstdayofmonth(toDate(Nov)) == initDate(2013, 11, 1)
    check firstdayofmonth(toDate(Dec)) == initDate(2013, 12, 1)

test "Test first/last day of week":
    # 2014-01-06 is a Monday = 1st day of week
    var a = initDate(2014, 1, 6)
    var b = initDate(2014, 1, 7)
    var c = initDate(2014, 1, 8)
    var d = initDate(2014, 1, 9)
    var e = initDate(2014, 1, 10)
    var f = initDate(2014, 1, 11)
    var g = initDate(2014, 1, 12)
    check firstdayofweek(a) == a
    check firstdayofweek(b) == a
    check firstdayofweek(c) == a
    check firstdayofweek(d) == a
    check firstdayofweek(e) == a
    check firstdayofweek(f) == a
    check firstdayofweek(g) == a

    # Test firstdayofweek over the course of the year
    var dt = a
    for i in 0..364:
        check firstdayofweek(dt) == a + Week(`div`(i, 7))
        dt = dt + Day(1)

    var a1 = initDateTime(2014, 1, 6)
    var b1 = initDateTime(2014, 1, 7)
    var c1 = initDateTime(2014, 1, 8)
    var d1 = initDateTime(2014, 1, 9)
    var e1 = initDateTime(2014, 1, 10)
    var f1 = initDateTime(2014, 1, 11)
    var g1 = initDateTime(2014, 1, 12)
    check firstdayofweek(a1) == a1
    check firstdayofweek(b1) == a1
    check firstdayofweek(c1) == a1
    check firstdayofweek(d1) == a1
    check firstdayofweek(e1) == a1
    check firstdayofweek(f1) == a1
    check firstdayofweek(g1) == a1

    var dt1 = a1
    for i in 0..364:
        check firstdayofweek(dt1) == a1 + Week(`div`(i, 7))
        dt1 = dt1 + Day(1)

    check firstdayofweek(initDateTime(2013, 12, 24)) == initDateTime(2013, 12, 23)
    # Test last day of week; Sunday = last day of week
    # 2014-01-12 is a Sunday
    a = initDate(2014, 1, 6)
    b = initDate(2014, 1, 7)
    c = initDate(2014, 1, 8)
    d = initDate(2014, 1, 9)
    e = initDate(2014, 1, 10)
    f = initDate(2014, 1, 11)
    g = initDate(2014, 1, 12)
    check lastdayofweek(a) == g
    check lastdayofweek(b) == g
    check lastdayofweek(c) == g
    check lastdayofweek(d) == g
    check lastdayofweek(e) == g
    check lastdayofweek(f) == g
    check lastdayofweek(g) == g
    dt = a
    for i in 0..364:
        check lastdayofweek(dt) == g + Week(`div`(i, 7))
        dt = dt + Day(1)

    a1 = initDateTime(2014, 1, 6)
    b1 = initDateTime(2014, 1, 7)
    c1 = initDateTime(2014, 1, 8)
    d1 = initDateTime(2014, 1, 9)
    e1 = initDateTime(2014, 1, 10)
    f1 = initDateTime(2014, 1, 11)
    g1 = initDateTime(2014, 1, 12)
    check lastdayofweek(a1) == g1
    check lastdayofweek(b1) == g1
    check lastdayofweek(c1) == g1
    check lastdayofweek(d1) == g1
    check lastdayofweek(e1) == g1
    check lastdayofweek(f1) == g1
    check lastdayofweek(g1) == g1

    dt1 = a1
    for i in 0..364:
        check lastdayofweek(dt1) == g1 + Week(`div`(i, 7))
        dt1 = dt1 + Day(1)

    check lastdayofweek(initDateTime(2013, 12, 24)) == initDateTime(2013, 12, 29)

test "first/last day of quarter":
    check firstdayofquarter(initDate(2014, 2, 2)) == initDate(2014, 1, 1)
    check firstdayofquarter(initDate(2014, 5, 2)) == initDate(2014, 4, 1)
    check firstdayofquarter(initDate(2014, 8, 2)) == initDate(2014, 7, 1)
    check firstdayofquarter(initDate(2014, 12, 2)) == initDate(2014, 10, 1)

    check firstdayofquarter(initDateTime(2014, 2, 2)) == initDateTime(2014, 1, 1)
    check firstdayofquarter(initDateTime(2014, 5, 2)) == initDateTime(2014, 4, 1)
    check firstdayofquarter(initDateTime(2014, 8, 2)) == initDateTime(2014, 7, 1)
    check firstdayofquarter(initDateTime(2014, 12, 2)) == initDateTime(2014, 10, 1)

    check lastdayofquarter(initDate(2014, 2, 2)) == initDate(2014, 3, 31)
    check lastdayofquarter(initDate(2014, 5, 2)) == initDate(2014, 6, 30)
    check lastdayofquarter(initDate(2014, 8, 2)) == initDate(2014, 9, 30)
    check lastdayofquarter(initDate(2014, 12, 2)) == initDate(2014, 12, 31)

    check lastdayofquarter(initDateTime(2014, 2, 2)) == initDateTime(2014, 3, 31)
    check lastdayofquarter(initDateTime(2014, 5, 2)) == initDateTime(2014, 6, 30)
    check lastdayofquarter(initDateTime(2014, 8, 2)) == initDateTime(2014, 9, 30)
    check lastdayofquarter(initDateTime(2014, 12, 2)) == initDateTime(2014, 12, 31)

test "first/last day of year":
    let firstday = initDate(2014, 1, 1)
    let lastday = initDate(2014, 12, 31)
    for i in 0..364:
        let dt = firstday + Day(i)

        check firstdayofyear(dt) == firstday
        check firstdayofyear(toDateTime(dt)) == toDateTime(firstday)

        check lastdayofyear(dt) == lastday
        check lastdayofyear(toDateTime(dt)) == toDateTime(lastday)


suite "Adjusters":
    setup:
        {.push hint[XDeclaredButNotUsed]:off.}
        var dt = initDate(2014, 5, 21)
        let Mon = 1
        let Tue = 2
        let Wed = 3
        let Thu = 4
        let Fri = 5
        let Sat = 6
        let Sun = 7
        proc istrue(x: Date): bool = true
        let dr = initDate(2014)..initDate(2015)

    test "Adjuster Constructors":
        check getDate(ismonday, 2014) == initDate(2014, 1, 6)
        check getDate(ismonday, 2014, 5) == initDate(2014, 5, 5)

        check getDateTime(ismonday, 2014, step = 1.Day) == initDateTime(2014, 1, 6)
        check getDateTime(ismonday, 2014, 5, step = 1.Day) == initDateTime(2014, 5, 5)
        check getDateTime(proc(x: DateTime):bool = hour(x)==12, 2014, 5, 21, step=1.Hour) ==
              initDateTime(2014, 5, 21, 12)
        check getDateTime(proc(x: DateTime): bool = minute(x)==30, 2014, 5, 21, 12, step=1.Minute) ==
              initDateTime(2014, 5, 21, 12, 30)
        check getDateTime(proc(x: DateTime): bool = second(x)==30, 2014, 5, 21, 12, 30, step=1.Second) ==
              initDateTime(2014, 5, 21, 12, 30, 30)
        check getDateTime(proc(x: DateTime): bool = millisecond(x)==500, 2014, 5, 21, 12, 30, 30, step=1.Millisecond) ==
              initDateTime(2014, 5, 21, 12, 30, 30, 500)

    test "tonext, toprev, tofirst, tolast":
        check tonext(dt, 3) == initDate(2014, 5, 28)
        check tonext(dt, 3, same=true) == dt
        check tonext(dt, 4) == initDate(2014, 5, 22)
        check tonext(dt, 5) == initDate(2014, 5, 23)
        check tonext(dt, 6) == initDate(2014, 5, 24)
        check tonext(dt, 7) == initDate(2014, 5, 25)
        check tonext(dt, 1) == initDate(2014, 5, 26)
        check tonext(dt, 2) == initDate(2014, 5, 27)
        # No dayofweek function for out of range values
        expect ValueError:
            discard tonext(dt, 8)

        check tonext(initDate(0), 1) == initDate(0, 1, 3)

    test "test func, diff steps, same":
        check tonext(iswednesday, dt, step=1.Day) == initDate(2014, 5, 28)
        check tonext(iswednesday, dt, same=true, step=1.Day) == dt
        check tonext(isthursday, dt, step=1.Day) == initDate(2014, 5, 22)
        check tonext(isfriday, dt, step=1.Day) == initDate(2014, 5, 23)
        check tonext(issaturday, dt, step=1.Day) == initDate(2014, 5, 24)
        check tonext(issunday, dt, step=1.Day) == initDate(2014, 5, 25)
        check tonext(ismonday, dt, step=1.Day) == initDate(2014, 5, 26)
        check tonext(istuesday, dt, step=1.Day) == initDate(2014, 5, 27)
        check tonext(ismonday, initDate(0), step=1.Day) == initDate(0, 1, 3)

        check tonext(proc(x: Date):bool = not iswednesday(x), dt, step=1.Day) == initDate(2014, 5, 22)
        check tonext(proc(x: Date): bool = not isthursday(x), dt, step=1.Day) == initDate(2014, 5, 23)

    test "Reach adjust limit":
        expect ValueError:
            discard tonext(iswednesday, dt, step=1.Day, limit=6)

    test "other tonext":
        check tonext(iswednesday, dt, step=Day(2)) == initDate(2014, 6, 4)
        check tonext(iswednesday, dt, step=Day(3)) == initDate(2014, 6, 11)
        check tonext(iswednesday, dt, step=Day(4)) == initDate(2014, 6, 18)
        check tonext(iswednesday, dt, step=Day(5)) == initDate(2014, 6, 25)
        check tonext(iswednesday, dt, step=Day(6)) == initDate(2014, 7, 2)
        check tonext(iswednesday, dt, step=Day(7)) == initDate(2014, 5, 28)
        check tonext(iswednesday, dt, step=Week(1)) == initDate(2014, 5, 28)
        check tonext(iswednesday, dt, step=Week(2)) == initDate(2014, 6, 4)
        check tonext(iswednesday, dt, step=Week(3)) == initDate(2014, 6, 11)
        check tonext(iswednesday, dt, step=Week(4)) == initDate(2014, 6, 18)
        check tonext(iswednesday, dt, step=Week(5)) == initDate(2014, 6, 25)
        check tonext(iswednesday, dt, step=Week(6)) == initDate(2014, 7, 2)

        check tonext(iswednesday, dt, same=true, step=1.Day) == dt
        check tonext(isthursday, dt, step=1.Day) == initDate(2014, 5, 22)

    test "toprev":
        check toprev(dt, 3) == initDate(2014, 5, 14)
        check toprev(dt, 3, same=true) == dt
        check toprev(dt, 4) == initDate(2014, 5, 15)
        check toprev(dt, 5) == initDate(2014, 5, 16)
        check toprev(dt, 6) == initDate(2014, 5, 17)
        check toprev(dt, 7) == initDate(2014, 5, 18)
        check toprev(dt, 1) == initDate(2014, 5, 19)
        check toprev(dt, 2) == initDate(2014, 5, 20)
        # No dayofweek function for out of range values
        expect ValueError:
            discard toprev(dt, 8)

        check toprev(initDate(0), 1) == initDate(-1, 12, 27)

    test "tofirst":
        check tofirst(dt, Mon, period=TMonth) == initDate(2014, 5, 5)
        check tofirst(dt, Tue, period=TMonth) == initDate(2014, 5, 6)
        check tofirst(dt, Wed, period=TMonth) == initDate(2014, 5, 7)
        check tofirst(dt, Thu, period=TMonth) == initDate(2014, 5, 1)
        check tofirst(dt, Fri, period=TMonth) == initDate(2014, 5, 2)
        check tofirst(dt, Sat, period=TMonth) == initDate(2014, 5, 3)
        check tofirst(dt, Sun, period=TMonth) == initDate(2014, 5, 4)

        check tofirst(dt, Mon, period=TYear) == initDate(2014, 1, 6)
        check tofirst(dt, Tue, period=TYear) == initDate(2014, 1, 7)
        check tofirst(dt, Wed, period=TYear) == initDate(2014, 1, 1)
        check tofirst(dt, Thu, period=TYear) == initDate(2014, 1, 2)
        check tofirst(dt, Fri, period=TYear) == initDate(2014, 1, 3)
        check tofirst(dt, Sat, period=TYear) == initDate(2014, 1, 4)
        check tofirst(dt, Sun, period=TYear) == initDate(2014, 1, 5)

        check tofirst(initDate(0), Mon, period=TMonth) == initDate(0, 1, 3)

    test "tolast":
        check tolast(dt, Mon, period=TMonth) == initDate(2014, 5, 26)
        check tolast(dt, Tue, period=TMonth) == initDate(2014, 5, 27)
        check tolast(dt, Wed, period=TMonth) == initDate(2014, 5, 28)
        check tolast(dt, Thu, period=TMonth) == initDate(2014, 5, 29)
        check tolast(dt, Fri, period=TMonth) == initDate(2014, 5, 30)
        check tolast(dt, Sat, period=TMonth) == initDate(2014, 5, 31)
        check tolast(dt, Sun, period=TMonth) == initDate(2014, 5, 25)

        check tolast(dt, Mon, period=TYear) == initDate(2014, 12, 29)
        check tolast(dt, Tue, period=TYear) == initDate(2014, 12, 30)
        check tolast(dt, Wed, period=TYear) == initDate(2014, 12, 31)
        check tolast(dt, Thu, period=TYear) == initDate(2014, 12, 25)
        check tolast(dt, Fri, period=TYear) == initDate(2014, 12, 26)
        check tolast(dt, Sat, period=TYear) == initDate(2014, 12, 27)
        check tolast(dt, Sun, period=TYear) == initDate(2014, 12, 28)

        check tolast(initDate(0), Mon, period=TMonth) == initDate(0, 1, 31)

    test "recur (in julia: recur)":
        let startdate = initDate(2014, 1, 1)
        let stopdate = initDate(2014, 2, 1)
        check len(recur(startdate, stopdate, step= 1.Day, proc(x:Date):bool = true)) == 32
        check len(recur(stopdate, startdate, step= -1.Day, proc(x:Date):bool = true)) == 32

        let Januarymondays2014 = @[initDate(2014, 1, 6), initDate(2014, 1, 13), initDate(2014, 1, 20), initDate(2014, 1, 27)]
        check recur(startdate, stopdate, step= 1.Day, proc(x: Date): bool = ismonday(x)) == Januarymondays2014

        check len(recur(initDate(2013),initDate(2013, 2), step= 1.Day, istrue)) == 32
        check len(recur(initDate(2013),initDate(2013, 1, 1), step= 1.Day, istrue)) == 1
        check len(recur(initDate(2013),initDate(2013, 1, 2), step= 1.Day, istrue)) == 2
        check len(recur(initDate(2013),initDate(2013, 1, 3), step= 1.Day, istrue)) == 3
        check len(recur(initDate(2013),initDate(2013, 1, 4), step= 1.Day, istrue)) == 4
        check len(recur(initDate(2013),initDate(2013, 1, 5), step= 1.Day, istrue)) == 5
        check len(recur(initDate(2013),initDate(2013, 1, 6), step= 1.Day, istrue)) == 6
        check len(recur(initDate(2013),initDate(2013, 1, 7), step= 1.Day, istrue)) == 7
        check len(recur(initDate(2013),initDate(2013, 1, 8), step= 1.Day, istrue)) == 8
        check len(recur(initDate(2013),initDate(2013, 1, 1), step= 1.Month, istrue)) == 1
        check len(recur(initDate(2013),initDate(2012, 1, 1), step= -1.Day, istrue)) == 367

    test "Empty range":
        check len(recur(initDate(2013),initDate(2012, 1, 1), step= 1.Day, istrue)) == 0

    test "All leap days in 20th century":
        check len(recur(initDate(1900),initDate(2000), step= 1.Day) do (x:Date) -> bool:
            month(x) == 2 and day(x) == 29) == 24

    test "Thanksgiving: 4th Thursday of November":
        proc thanksgiving(x: Date): bool =
            dayofweek(x) == Thu and
                month(x) == 11 and
                dayofweekofmonth(x) == 4

        let d = initDate(2014, 6, 5)

        check tonext(thanksgiving, d, step= 1.Day) == initDate(2014, 11, 27)

        check toprev(thanksgiving, d, step= 1.Day) == initDate(2013, 11, 28)

    test "Pittsburgh street cleaning":
        check len(recur(dr.a, dr.b, step= 1.Day ) do (x: Date) -> bool:
            dayofweek(x) == Tue and
                4 < month(x) and month(x) < 11 and
                    dayofweekofmonth(x) == 2) == 6

    test "U.S. Federal Holidays":
        proc newyears(y: int):(int, int, int) = (y, 1, 1)
        proc independenceday(y: int):(int,int,int) = (y, 7, 4)
        proc veteransday(y: int):(int,int,int) = (y, 11, 11)
        proc christmas(y: int):(int,int,int) = (y, 12, 25)

        proc isnewyears(dt: Date):bool = yearmonthday(dt) == newyears(year(dt).int)
        proc isindependenceday(dt: Date):bool = yearmonthday(dt) == independenceday(year(dt).int)
        proc isveteransday(dt: Date):bool = yearmonthday(dt) == veteransday(year(dt).int)
        proc ischristmas(dt: Date):bool = yearmonthday(dt) == christmas(year(dt).int)
        proc ismartinlutherking(dt: Date):bool =
            dayofweek(dt) == Mon and
                month(dt) == 1 and dayofweekofmonth(dt) == 3
        proc ispresidentsday(dt: Date):bool =
            dayofweek(dt) == Mon and
                month(dt) == 2 and dayofweekofmonth(dt) == 3
        # Last Monday of May
        proc ismemorialday(dt: Date):bool =
            dayofweek(dt) == Mon and
                month(dt) == 5 and
                    dayofweekofmonth(dt) == daysofweekinmonth(dt)
        proc islaborday(dt: Date):bool =
            dayofweek(dt) == Mon and
                month(dt) == 9 and dayofweekofmonth(dt) == 1
        proc iscolumbusday(dt: Date):bool =
            dayofweek(dt) == Mon and
                month(dt) == 10 and dayofweekofmonth(dt) == 2
        proc isthanksgiving(dt: Date):bool =
            dayofweek(dt) == Thu and
                month(dt) == 11 and dayofweekofmonth(dt) == 4

        proc easter(y: int):(int,int,int) =
            # Butcher's Algorithm: http://www.smart.net/~mmontes/butcher.html
            let a = y mod 19
            let b = `div`(y, 100)
            let c = y mod 100
            let d = `div`(b, 4)
            let e = b mod 4
            let f = `div`(b + 8, 25)
            let g = `div`(b - f + 1, 3)
            let h = (19 * a + b - d - g + 15) mod 30
            let i = `div`(c, 4)
            let k = c mod 4
            let l = (32 + 2 * e + 2 * i - h - k) mod 7
            let m = `div`(a + 11 * h + 22 * l, 451)
            let month = `div`(h + l - 7 * m + 114, 31)
            let p = (h + l - 7 * m + 114) mod 31
            result = (y, month, p + 1)

        proc iseaster(dt: Date):bool = yearmonthday(dt) == easter(year(dt).int)

        proc HOLIDAYS(x: Date): bool =
            result = isnewyears(x) or isindependenceday(x) or
                            isveteransday(x) or ischristmas(x) or
                            ismartinlutherking(x) or ispresidentsday(x) or
                            ismemorialday(x) or islaborday(x) or
                            iscolumbusday(x) or isthanksgiving(x)

        check len(recur(dr.a, dr.b, step= 1.Day, HOLIDAYS)) == 11
        for x in recur(firstdayofyear(today() + 1.Year),
                       lastdayofyear(today() + 1.Year), step= 1.Day, HOLIDAYS):
            echo x

        proc OBSERVEDHOLIDAYS(x:Date):bool =
            # If the holiday is on a weekday
            if HOLIDAYS(x) and dayofweek(x) < Sat:
                return true
            # Holiday is observed Monday if falls on Sunday
            elif dayofweek(x) == 1 and HOLIDAYS(x - Day(1)):
                return true
            # Holiday is observed Friday if falls on Saturday
            elif dayofweek(x) == 5 and HOLIDAYS(x + Day(1)):
                return true
            else:
                return false

        let observed = recur(initDate(1999), initDate(2000), step= 1.Day, OBSERVEDHOLIDAYS)
        check len(observed) == 11
        check observed[9] == initDate(1999, 12, 24)
        check observed[10] == initDate(1999, 12, 31)

        # Get all business/working days of 2014
        # Since we have already defined observed holidays,
        # we just look at weekend days and negate the result
        #proc notOBSERVEDHOLIDAYS(x:Date):bool = not OBSERVEDHOLIDAYS(x)
        check len(recur(initDate(2014), initDate(2015), step= 1.Day) do (x:Date) -> bool:
            not (OBSERVEDHOLIDAYS(x) or dayofweek(x) > 5)) == 251

    test "First day of the next month for each day of 2014":
        check len(lc[firstdayofmonth(x) | (x <- recur(initDate(2014), initDate(2014,12,31), step= 1.Day, proc(x:Date):bool = true)), Date]) == 365




suite """From those goofy email forwards claiming a "special, lucky month":
      that has 5 Fridays, 5 Saturdays, and 5 Sundays and that it only
      occurs every 823 years""":
    test "lucky month":
        check len(recur(initDate(2000), initDate(2016), step= 1.Month) do (dt: Date) -> bool:
            var dt = dt
            var sum = 0
            for i in 1..7:
                sum += (if dayofweek(dt) > 4: daysofweekinmonth(dt) else: 0)
                dt = dt + Day(1)
            return sum == 15) == 15 # On average, there's one of those months every year

suite "Time recurrence":
    test "simple getTime":
        let r = getTime(proc(x:Time):bool = second(x) == 5, 1, step = 1.Second)
        check r == initTime(1, 0, 5)

    test "Second 5 per Minute for 10 Hours":
        let r = recur(initTime(0), initTime(10), step= 1.Second, proc(x: Time):bool = second(x) == 5)
        check len(r) == 600
        check r[0] == initTime(0, 0, 5)
        check r[^1] == initTime(9, 59, 5)

