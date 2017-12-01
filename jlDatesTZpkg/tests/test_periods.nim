import ../../jlDatesTZ
import unittest


let y = Year(1)
let m = Month(1)
let w = Week(1)
let d = Day(1)
let h = Hour(1)
let mi = Minute(1)
let s = Second(1)
let ms = Millisecond(1)
let us = Microsecond(1)
let ns = Nanosecond(1)

test "Period testing":
    check -Year(1) == Year(-1)
    check Year(1) > Year(0)
    check (Year(1) < Year(0)) == false
    check Year(1) == Year(1)
    check Year(1) + Year(1) == Year(2)
    check Year(1) - Year(1) == Year(0)

    check Year(10) mod Year(4) == Year(2)
    check gcd(Year(10), Year(4)) == Year(2)
    check lcm(Year(10), Year(4)) == Year(20)
    check `div`(Year(10), Year(3)) == 3
    check `div`(Year(10), Year(4)) == 2
    check `div`(Year(10), 4) == Year(2)
    check Year(10) / Year(4) == 2.5

    check modulo(Year(10), Year(4)) == Year(2)
    check modulo(Year(-10), Year(4)) == Year(2)
    check modulo(Year(10), 4) == Year(2)
    check modulo(Year(-10), 4) == Year(2)

    check `mod`(Year(10), Year(4)) == Year(2)
    check `mod`(Year(-10), Year(4)) == Year(-2)
    check `mod`(Year(10), 4) == Year(2)
    check `mod`(Year(-10), 4) == Year(-2)

    let t = Year(1)
    check abs(-t) == t

test "Period arithmetic":
    check y == y
    check m == m
    check w == w
    check d == d
    check h == h
    check mi == mi
    check s == s
    check ms == ms
    check us == us
    check ns == ns
    let y2 = Year(2)
    check y < y2
    check y2 > y
    check y != y2

    check Year(int8(1)) == y
    check Year(uint8(1)) == y
    check Year(int16(1)) == y
    check Year(uint16(1)) == y
    check Year(int(1)) == y
    check Year(uint(1)) == y
    check Year(int64(1)) == y
    check Year(uint64(1)) == y
    check Year(float(1)) == y
    check Year(float32(1)) == y
    check Year(initDate(2013, 1, 1)) == Year(2013)
    check Year(initDateTime(2013, 1, 1)) == Year(2013)
    check (y + m) is TCompoundPeriod
    check (m + y) is TCompoundPeriod
    check (y + w) is TCompoundPeriod
    check (y + d) is TCompoundPeriod
    check (y + h) is TCompoundPeriod
    check (y + mi) is TCompoundPeriod
    check (y + s) is TCompoundPeriod
    check (y + ms) is TCompoundPeriod
    check (y + us) is TCompoundPeriod
    check (y + ns) is TCompoundPeriod
    check initCompoundPeriod(y) > initCompoundPeriod(m)
    check d < w
    check mi < h
    check ms < h
    check ms < mi
    check us < ms
    check ns < ms
    check ns < us
    check ns < w
    check us < w
# check typemax(Year) == Year(typemax(Int64))
# check typemax(Year) + y == Year(-9223372036854775808)
# check typemin(Year) == Year(-9223372036854775808)

# #Period-Real arithmetic
# check_throws MethodError y + 1 == Year(2)
# check_throws MethodError y + true == Year(2)
# check_throws InexactError y + Year(1.2)
    check y + Year(1.0) == Year(2)
    check y * 4 == Year(4)
# check_throws InexactError y * 3//4 == Year(1)
    check `div`(y, 2) == Year(0)
# check_throws MethodError div(2, y) == Year(2)
    check `div`(y, y) == 1
    check y*10 mod Year(5) == Year(0)
# check_throws MethodError (y > 3) == false
# check_throws MethodError (4 < y) == false
# check 1 != y
# t = [y, y, y, y, y]
# check t .+ Year(2) == [Year(3), Year(3), Year(3), Year(3), Year(3)]

    let
        x1 = Year(5)
        y1 = Year(2)
    check((`div`(x1, y1).int * y1 + `mod`(x1, y1)) == x1)
    check fld(x1, y1) * y1 + modulo(x1, y1) == x1
# end

test "Associativity":
    var dt = initDateTime(2012, 12, 21)
    let test = ((((((((dt + y) - m) + w) - d) + h) - mi) + s) - ms)
    check test == dt + (y - m + w - d + h - mi + s - ms)
    check test == (y - m + w - d) + dt + (h - mi + s - ms)
    check test == dt + (-m + y - d + w - mi + h - ms + s)
    check test == dt + (y - m + w - d + h - mi + s - ms)
    check test == dt + (y - m + w - d + (h - mi + s - ms))
    check (dt + Year(4)) + Day(1) == dt + (Year(4) + Day(1))
    check initDate(2014, 1, 29) + (Month(1) + Day(1) + Month(1) + Day(1)) ==
        initDate(2014, 1, 29) + (Day(1) + Month(1) + Month(1) + Day(1))
    check initDate(2014, 1, 29) + (Month(1) + Day(1)) == initDate(2014, 1, 29) + (Day(1) + Month(1))
    # traits
    check $(Year(0)) == "0 years"
    check $(Year(1)) == "1 year"
    check $(Year(-1)) == "-1 year"
    check $(Year(2)) == "2 years"

    check Year(-1) < Year(1)
    check (not (Year(-1) > Year(1)))
    check Year(1) == Year(1)

    check Month(-1) < Month(1)
    check (not (Month(-1) > Month(1)))
    check Month(1) == Month(1)

    check Day(-1) < Day(1)
    check (not (Day(-1) > Day(1)))
    check Day(1) == Day(1)

    check Hour(-1) < Hour(1)
    check (not (Hour(-1) > Hour(1)))
    check Hour(1) == Hour(1)

    check Minute(-1) < Minute(1)
    check (not (Minute(-1) > Minute(1)))
    check Minute(1) == Minute(1)

    check Second(-1) < Second(1)
    check (not (Second(-1) > Second(1)))
    check Second(1) == Second(1)

    check Millisecond(-1) < Millisecond(1)
    check (not (Millisecond(-1) > Millisecond(1)))
    check Millisecond(1) == Millisecond(1)


test "Conversions":
    check toms(ms) == value(Millisecond(ms)) and toms(ms) ==  1
    check toms(s)  == value(Millisecond(s)) and toms(s) == 1000
    check toms(mi) == value(Millisecond(mi)) and toms(mi) == 60000
    check toms(h)  == value(Millisecond(h)) and toms(h) == 3600000
    check toms(d)  == value(Millisecond(d)) and toms(d) == 86400000
    check toms(w)  == value(Millisecond(w)) and toms(w) == 604800000

    check days(ms) == 0 and days(s) == 0 and days(mi) == 0 and days(h) == 0
    check days(Millisecond(86400000)) == 1
    check days(Second(86400)) == 1
    check days(Minute(1440)) == 1
    check days(Hour(24)) == 1
    check days(d) == 1
    check days(w) == 7

test "julialang issue #9214":
    check 2 * s + (7 * ms + 1 * ms) == (2 * s + 7 * ms) + 1 * ms
    check 1 * ms + (2 * s + 7 * ms) == 1 * ms + (1 * s + 7*ms) + 1*s
    check 1*ms + (2*s + 3*d + 7*ms) + (-3*d) == (1*ms + (2*s + 3*d)) + (7*ms - 3*d)
    check 2 * s + (7 * ms + 1 * ms) == (1*ms + (2*s + 3*d)) - (3*d - 7*ms)
    check 1 * ms - (2 * s + 7 * ms) == -((2 * s + 7 * ms) - 1* ms)
    check 1 * ms - (2 * s + 7 * ms) == (-6 * ms) - 2 * s
    let emptyperiod = ((y + d) - d) - y
    check emptyperiod == ((d + y) - y) - d and emptyperiod == ((d + y) - d) - y
    check emptyperiod == 2 * y + (m - d) + ms - ((m - d) + 2 * y + ms)
    check emptyperiod == 0 * ms + 0.Second
    check $(emptyperiod) == "empty period"
    check $(ms + mi + d + m + y + w + h + s + 2 * y + m) == "3 years, 2 months, 1 week, 1 day, 1 hour, 1 minute, 1 second, 1 millisecond"
    check 8 * d - s == 1 * w + 23 * h + 59 * mi + 59 * s
    check h + 3 * mi == 63 * mi + 0.Second
    check y - m == 11 * m + 0.Second


test "reduce compound periods into the most basic form":
    check canonicalize(h - mi) == initCompoundPeriod(59 * mi)
    check canonicalize(-h + mi) == initCompoundPeriod(-59 * mi)
    check canonicalize(-y + d) == initCompoundPeriod(-y) + d
    check canonicalize(-y + m - w + d) == initCompoundPeriod(-11*m) - 6*d
    check canonicalize(-y + m - w + ms) == initCompoundPeriod(-11*m) + -6*d + -23*h + -59*mi + -59*s + -999*ms
    check canonicalize(y - m + w - d + h - mi + s - ms) == initCompoundPeriod(11*m) + 6*d + 59*mi + 999*ms
    check canonicalize(-y + m - w + d - h + mi - s + ms) == initCompoundPeriod(-11*m) + -6*d + -59*mi + -999*ms

check initDate(2009, 2, 1) - (Month(1) + Day(1)) == initDate(2008, 12, 31)


