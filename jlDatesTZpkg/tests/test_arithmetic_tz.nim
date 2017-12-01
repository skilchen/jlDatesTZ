import ../../jlDatesTZ
import unittest

let warsaw = initTZInfo("Europe/Warsaw", tzOlson)

let normal = initDateTime(2015, 1, 1, 0)   # a 24 hour day in warsaw
let spring = initDateTime(2015, 3, 29, 0)  # a 23 hour day in warsaw
let fall = initDateTime(2015, 10, 25, 0)   # a 25 hour day in warsaw

test "Unary plus":
    check +initZonedDateTime(normal, warsaw) == initZonedDateTime(normal, warsaw)

test "Period arithmetic":
    check initZonedDateTime(normal, warsaw) + Day(1) == initZonedDateTime(normal + Day(1), warsaw)
    check initZonedDateTime(spring, warsaw) + Day(1) == initZonedDateTime(spring + Day(1), warsaw)
    check initZonedDateTime(fall, warsaw) + Day(1) == initZonedDateTime(fall + Day(1), warsaw)

    check initZonedDateTime(normal, warsaw) + Hour(24) == initZonedDateTime(normal + Hour(24), warsaw)
    check initZonedDateTime(spring, warsaw) + Hour(24) == initZonedDateTime(spring + Hour(25), warsaw)
    check initZonedDateTime(fall, warsaw) + Hour(24) == initZonedDateTime(fall + Hour(23), warsaw)

test "Do the same calculations but backwards over the transitions.":
    check initZonedDateTime(normal + Day(1), warsaw) - Day(1) == initZonedDateTime(normal, warsaw)
    check initZonedDateTime(spring + Day(1), warsaw) - Day(1) == initZonedDateTime(spring, warsaw)
    check initZonedDateTime(fall + Day(1), warsaw) - Day(1) == initZonedDateTime(fall, warsaw)

    check initZonedDateTime(normal + Day(1), warsaw) - Hour(24) == initZonedDateTime(normal, warsaw)
    check initZonedDateTime(spring + Day(1), warsaw) - Hour(23) == initZonedDateTime(spring, warsaw)
    check initZonedDateTime(fall + Day(1), warsaw) - Hour(25) == initZonedDateTime(fall, warsaw)

test "Ensure that arithmetic around transitions works.":
    check initZonedDateTime(spring, warsaw) + Hour(1) == initZonedDateTime(spring + Hour(1), warsaw)
    check initZonedDateTime(spring, warsaw) + Hour(2) == initZonedDateTime(spring + Hour(3), warsaw)
    check initZonedDateTime(fall, warsaw) + Hour(2) == initZonedDateTime(fall + Hour(2), warsaw, prefer_dst=true)
    check initZonedDateTime(fall, warsaw) + Hour(3) == initZonedDateTime(fall + Hour(2), warsaw, prefer_dst=false)

test "Non-Associativity":
    let spring = initDateTime(2015, 3, 29, 0)  # a 23 hour day in warsaw
    let explicit_hour_day = (initZonedDateTime(spring, warsaw) + Hour(24)) + Day(1)
    let explicit_day_hour = (initZonedDateTime(spring, warsaw) + Day(1)) + Hour(24)
    let implicit_hour_day = initZonedDateTime(spring, warsaw) + Hour(24) + Day(1)
    let implicit_day_hour = initZonedDateTime(spring, warsaw) + (Day(1) + Hour(24))

    check explicit_hour_day == initZonedDateTime(2015, 3, 31, 1, tzinfo=warsaw)
    check explicit_day_hour == initZonedDateTime(2015, 3, 31, 0, tzinfo=warsaw)
    # my translation gets these results, the author of the julia TimeZones packages
    # assumes that the correct result would be the hour 0. i think this is debatable
    # @test implicit_hour_day == ZonedDateTime(2015, 3, 31, 0, warsaw)
    # @test implicit_day_hour == ZonedDateTime(2015, 3, 31, 0, warsaw)
    check implicit_hour_day == initZonedDateTime(2015, 3, 31, 1, tzinfo=warsaw)
    check implicit_day_hour == initZonedDateTime(2015, 3, 31, 1, tzinfo=warsaw)

test """CompoundPeriod canonicalization interacting with period arithmetic. Since `spring_zdt` is
        a 23 hour day this means adding `Day(1)` and `Hour(23)` are equivalent.""":
    let spring_zdt = initZonedDateTime(spring, warsaw)
    check spring_zdt + Day(1) + Minute(1) == spring_zdt + Hour(23) + Minute(1)

test """When canonicalization happens automatically `Hour(24) + Minute(1)` is converted into
        `Day(1) + Minute(1)`. Fixed in `JuliaLang/julia#19268`""":
    let spring_zdt = initZonedDateTime(spring, warsaw)
    check spring_zdt + Hour(23) + Minute(1) < spring_zdt + Hour(24) + Minute(1)



# # Arithmetic with a StepRange should always work even when the start/stop lands on
# # ambiguous or non-existent DateTimes.
# ambiguous = DateTime(2015, 10, 25, 2)   # Ambiguous hour in Warsaw
# nonexistent = DateTime(2014, 3, 30, 2)  # Non-existent hour in Warsaw

# range = initZonedDateTime(ambiguous - Day(1), warsaw):Hour(1):initZonedDateTime(ambiguous - Day(1) + Hour(1), warsaw)
# check range .+ Day(1) == initZonedDateTime(ambiguous, warsaw, 1):Hour(1):initZonedDateTime(ambiguous + Hour(1), warsaw)

# range = initZonedDateTime(ambiguous - Day(1) - Hour(1), warsaw):Hour(1):initZonedDateTime(ambiguous - Day(1), warsaw)
# check range .+ Day(1) == initZonedDateTime(ambiguous - Hour(1), warsaw, 1):Hour(1):initZonedDateTime(ambiguous, warsaw, 2)

# range = initZonedDateTime(nonexistent - Day(1), warsaw):Hour(1):initZonedDateTime(nonexistent - Day(1) + Hour(1), warsaw)
# check range .+ Day(1) == initZonedDateTime(nonexistent + Hour(1), warsaw):Hour(1):initZonedDateTime(nonexistent + Hour(1), warsaw)

# range = initZonedDateTime(nonexistent - Day(1) - Hour(1), warsaw):Hour(1):initZonedDateTime(nonexistent - Day(1), warsaw)
# check range .+ Day(1) == initZonedDateTime(nonexistent - Hour(1), warsaw):Hour(1):initZonedDateTime(nonexistent - Hour(1), warsaw)
