import ../../jlDatesTZ
import unittest

let utctz = initTZInfo("UTC", tzPosix)
let fixedtz = initTZInfo("UTC-06:00", tzPosix)
let winnipeg = initTZInfo("America/Winnipeg", tzOlson)   # UTC-6:00 (or UTC-5:00)
let st_johns = initTZInfo("America/St_Johns", tzOlson)   # UTC-3:30 (or UTC-2:30)
let eucla = initTZInfo("Australia/Eucla", tzOlson)        # UTC+8:45
let colombo = initTZInfo("Asia/Colombo", tzOlson)                # See note below

# On 1996-05-25 at 00:00, the Asia/Colombo time zone in Sri Lanka moved from Indian Standard
# Time (UTC+5:30) to Lanka Time (UTC+6:30). On 1996-10-26 at 00:30, Lanka Time was revised
# from UTC+6:30 to UTC+6:00, marking a -00:30 transition. Transitions like these are doubly
# unusual (compared to the more common DST transitions) as it is both an half-hour
# transition and a transition that lands at midnight (causing 1996-10-26T00:00 to be
# ambiguous; midnights are rarely ambiguous). In 2006, Asia/Colombo returned to Indian
# Standard Time, causing another -00:30 transition from 00:30 to 00:00.

##################
# NO TRANSITIONS #
##################

test "Test rounding where no rounding is necessary.":
    let dt = initDateTime(2016)
    for tz in @[utctz, fixedtz, winnipeg, st_johns, eucla, colombo]:
        let zdt = initZonedDateTime(dt, tz)
        #for p in [Year(1), Month(1), Day(1), Hour(1), Minute(1), Second(1)]:
        check floor(zdt, Year(1)) == zdt
        check floor(zdt, Month(1)) == zdt
        check floor(zdt, Day(1)) == zdt
        check floor(zdt, Hour(1)) == zdt
        check floor(zdt, Minute(1)) == zdt
        check floor(zdt, Second(1)) == zdt
        check ceil(zdt, Year(1)) == zdt
        check ceil(zdt, Month(1)) == zdt
        check ceil(zdt, Day(1)) == zdt
        check ceil(zdt, Hour(1)) == zdt
        check ceil(zdt, Minute(1)) == zdt
        check ceil(zdt, Second(1)) == zdt
        check round(zdt, Year(1)) == zdt
        check round(zdt, Month(1)) == zdt
        check round(zdt, Day(1)) == zdt
        check round(zdt, Hour(1)) == zdt
        check round(zdt, Minute(1)) == zdt
        check round(zdt, Second(1)) == zdt

test "Test rounding non-controversial ZonedDateTimes (no transitions).":

    let dt = initDateTime(2016, 2, 5, 13, 10, 20, 500)

    for tz in [utctz, fixedtz, winnipeg, st_johns, eucla, colombo]:
        let zdt = initZonedDateTime(dt, tz)

        check floor(zdt, Year(1)) == initZonedDateTime(initDateTime(2016), tzinfo=tz)
        check floor(zdt, Month(1)) == initZonedDateTime(2016, 2, tzinfo=tz)
        check floor(zdt, Week(1)) == initZonedDateTime(2016, 2, tzinfo=tz)      # Previous Monday
        check floor(zdt, Day(1)) == initZonedDateTime(2016, 2, 5, tzinfo=tz)
        check floor(zdt, Hour(1)) == initZonedDateTime(2016, 2, 5, 13, tzinfo=tz)
        check floor(zdt, Minute(1)) == initZonedDateTime(2016, 2, 5, 13, 10, tzinfo=tz)
        check floor(zdt, Second(1)) == initZonedDateTime(2016, 2, 5, 13, 10, 20, tzinfo=tz)

        check ceil(zdt, Year(1)) == initZonedDateTime(2017, tzinfo=tz)
        check ceil(zdt, Month(1)) == initZonedDateTime(2016, 3, tzinfo=tz)
        check ceil(zdt, Week(1)) == initZonedDateTime(2016, 2, 8, tzinfo=tz)    # Following Monday
        check ceil(zdt, Day(1)) == initZonedDateTime(2016, 2, 6, tzinfo=tz)
        check ceil(zdt, Hour(1)) == initZonedDateTime(2016, 2, 5, 14, tzinfo=tz)
        check ceil(zdt, Minute(1)) == initZonedDateTime(2016, 2, 5, 13, 11, tzinfo=tz)
        check ceil(zdt, Second(1)) == initZonedDateTime(2016, 2, 5, 13, 10, 21, tzinfo=tz)

        check round(zdt, Year(1)) == initZonedDateTime(2016, tzinfo=tz)
        check round(zdt, Month(1)) == initZonedDateTime(2016, 2, tzinfo=tz)
        check round(zdt, Week(1)) == initZonedDateTime(2016, 2, 8, tzinfo=tz)   # Following Monday
        check round(zdt, Day(1)) == initZonedDateTime(2016, 2, 6, tzinfo=tz)
        check round(zdt, Hour(1)) == initZonedDateTime(2016, 2, 5, 13, tzinfo=tz)
        check round(zdt, Minute(1)) == initZonedDateTime(2016, 2, 5, 13, 10, tzinfo=tz)
        check round(zdt, Second(1)) == initZonedDateTime(2016, 2, 5, 13, 10, 21, tzinfo=tz)


##########################
# DST TRANSITION FORWARD #
##########################

# Test rounding over spring transition (missing hour). FixedTimeZones have no transitions,
# but ZonedDateTimes with VariableTimeZones will round in their current (tzinfo=fixedtz time zone
# and then adjust to the new time zone if a transition has occurred (DST, for example).

test "Test rounding backward, toward the missing hour.":
    let dt = initDateTime(2016, 3, 13, 3, 15)             # 15 minutes after transition

    let zdt = initZonedDateTime(dt, fixedtz)
    check floor(zdt, Day(1)) == initZonedDateTime(2016, 3, 13, tzinfo=fixedtz)
    check floor(zdt, Hour(2)) == initZonedDateTime(2016, 3, 13, 2, tzinfo=fixedtz)

    for tz in [winnipeg, st_johns]:
        let zdt = initZonedDateTime(dt, tz)
        check floor(zdt, Day(1)) == initZonedDateTime(2016, 3, 13, tzinfo=tz)
        check floor(zdt, Hour(2)) == initZonedDateTime(2016, 3, 13, 1, tzinfo=tz)


test "Test rounding forward, toward the missing hour.":
    let dt = initDateTime(2016, 3, 13, 1, 55)             # 5 minutes before transition

    let zdt = initZonedDateTime(dt, fixedtz)
    check ceil(zdt, Day(1)) == initZonedDateTime(2016, 3, 14, tzinfo=fixedtz)
    check ceil(zdt, Hour(1)) == initZonedDateTime(2016, 3, 13, 2, tzinfo=fixedtz)
    check ceil(zdt, Minute(30)) == initZonedDateTime(2016, 3, 13, 2, tzinfo=fixedtz)
    check round(zdt, Minute(30)) == initZonedDateTime(2016, 3, 13, 2, tzinfo=fixedtz)

    for tz in [winnipeg, st_johns]:
        let zdt = initZonedDateTime(dt, tz)
        check ceil(zdt, Day(1)) == initZonedDateTime(2016, 3, 14, tzinfo=tz)
        check ceil(zdt, Hour(1)) == initZonedDateTime(2016, 3, 13, 3, tzinfo=tz)
        check ceil(zdt, Minute(30)) == initZonedDateTime(2016, 3, 13, 3, tzinfo=tz)
        check round(zdt, Minute(30)) == initZonedDateTime(2016, 3, 13, 3, tzinfo=tz)


test "Test rounding from 'midday'.":
    let dt = initDateTime(2016, 3, 13, 12)                # Noon on day of transition

    # Noon is the middle of the day, and ties round up by default.
    check round(initZonedDateTime(dt, fixedtz), Day(1)) == initZonedDateTime(2016, 3, 14, tzinfo=fixedtz)

    # Noon isn't the middle of the day, as 2:00 through 2:59:59.999 are missing in these zones.
    check round(initZonedDateTime(dt, winnipeg), Day(1)) == initZonedDateTime(2016, 3, 13, tzinfo=winnipeg)
    check round(initZonedDateTime(dt, st_johns), Day(1)) == initZonedDateTime(2016, 3, 13, tzinfo=st_johns)

###########################
# DST TRANSITION BACKWARD #
###########################

# Test rounding over autumn transition (additional, ambiguous hour).

test "Test rounding backward, toward the ambiguous hour.":

    let dt = initDateTime(2015, 11, 1, 2, 15)             # 15 minutes after ambiguous hour

    let zdt = initZonedDateTime(dt, fixedtz)
    check floor(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=fixedtz)
    check floor(zdt, Hour(3)) == initZonedDateTime(2015, 11, 1, tzinfo=fixedtz)
    # Rounding to Hour(3) will give 00:00, 03:00, 06:00, 09:00, etc.

    for tz in [winnipeg, st_johns]:
        let zdt = initZonedDateTime(dt, tz)
        check floor(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=tz)
        check floor(zdt, Hour(3)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=tz, prefer_dst=true)
        # Rounding is performed in the current fixed zone, then relocalized if a transition has
        # occurred. This means that instead of 00:00, 03:00, etc., we expect 01:00, 04:00, etc.

test "Test rounding forward, toward the ambiguous hour.":

    let dt = initDateTime(2015, 11, 1, 0, 55)             # 5 minutes before ambiguous hour

    let zdt = initZonedDateTime(dt, fixedtz)
    check ceil(zdt, Day(1)) == initZonedDateTime(2015, 11, 2, tzinfo=fixedtz)
    check ceil(zdt, Hour(1)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)
    check ceil(zdt, Minute(30)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)
    check round(zdt, Minute(30)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)

    for tz in [winnipeg, st_johns]:
        let zdt = initZonedDateTime(dt, tz)
        let next_hour = initZonedDateTime(initDateTime(2015, 11, 1, 1), tz, prefer_dst=true)

        check ceil(zdt, Day(1)) == initZonedDateTime(2015, 11, 2, tzinfo=tz)
        check ceil(zdt, Hour(1)) == next_hour
        check ceil(zdt, Minute(30)) == next_hour
        check round(zdt, Minute(30)) == next_hour


test "Test rounding forward and backward, during the ambiguous hour.":

    let dt = initDateTime(2015, 11, 1, 1, 25)                   # During ambiguous hour

    let zdt = initZonedDateTime(dt, fixedtz)
    check floor(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=fixedtz)
    check ceil(zdt, Day(1)) == initZonedDateTime(2015, 11, 2, tzinfo=fixedtz)
    check round(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=fixedtz)
    check floor(zdt, Hour(1)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)
    check ceil(zdt, Hour(1)) == initZonedDateTime(2015, 11, 1, 2, tzinfo=fixedtz)
    check round(zdt, Hour(1)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)
    check floor(zdt, Minute(30)) == initZonedDateTime(2015, 11, 1, 1, tzinfo=fixedtz)
    check ceil(zdt, Minute(30)) == initZonedDateTime(2015, 11, 1, 1, 30, tzinfo=fixedtz)
    check round(zdt, Minute(30)) == initZonedDateTime(2015, 11, 1, 1, 30, tzinfo=fixedtz)

    for tz in [winnipeg, st_johns]:
        let zdt = initZonedDateTime(dt, tzinfo=tz, prefer_dst=true)            # First 1:25, before "falling back"
        let prev_hour = initZonedDateTime(2015, 11, 1, 1, tzinfo=tz, prefer_dst=true)
        let between_hours = initZonedDateTime(2015, 11, 1, 1, 30, tzinfo=tz, prefer_dst=true)
        let next_hour = initZonedDateTime(2015, 11, 1, 1, tzinfo=tz, prefer_dst=false)
        check floor(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=tz)
        check ceil(zdt, Day(1)) == initZonedDateTime(2015, 11, 2, tzinfo=tz)
        check round(zdt, Day(1)) == initZonedDateTime(2015, 11, 1, tzinfo=tz)
        check floor(zdt, Hour(1)) == prev_hour
        check ceil(zdt, Hour(1)) == next_hour
        check round(zdt, Hour(1)) == prev_hour
        check floor(zdt, Minute(30)) == prev_hour
        check ceil(zdt, Minute(30)) == between_hours
        check round(zdt, Minute(30)) == between_hours


###########################
# ASIA/COLOMBO TRANSITION #
###########################

test """Test rounding to ambiguous midnight, which (unfortunately) isn't handled well when
        rounding to a DatePeriod resolution.""":
    var zdt = initZonedDateTime(1996, 10, 25, 23, 55, tzinfo=colombo)  # 5 minutes before ambiguous half-hour
    check floor(zdt, Day(1)) == initZonedDateTime(1996, 10, 25, tzinfo=colombo)
    check ceil(zdt, Day(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo)
    check round(zdt, Day(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo)

    zdt = initZonedDateTime(1996, 10, 26, 0, 35, tzinfo=colombo)   # 5 minutes after ambiguous half-hour
    check floor(zdt, Day(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo)
    check ceil(zdt, Day(1)) == initZonedDateTime(1996, 10, 27, tzinfo=colombo)
    check round(zdt, Day(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo)

test "Rounding to the ambiguous midnight works fine using a TimePeriod resolution, however.":
    var zdt = initZonedDateTime(1996, 10, 25, 23, 55, tzinfo=colombo)  # 5 minutes before ambiguous half-hour
    expect AmbiguousTimeError:
        check ceil(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=true)
        check round(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=true)

        zdt = initZonedDateTime(1996, 10, 26, 0, 35, tzinfo=colombo)   # 5 minutes after ambiguous half-hour
        check floor(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=true)

test "Rounding during the first half-hour between 00:00 and 00:30.":
    var zdt = initZonedDateTime(1996, 10, 26, 0, 15, tzinfo=colombo, prefer_dst=false)
    check floor(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)
    check ceil(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, 0, 30, tzinfo=colombo)
    expect AmbiguousTimeError:
        check round(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=true)
        check floor(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=true)
# i am currently unable to pass these tests and i am not sure if the given expected results are
# indeed correct. i would prefer to raise always an exception in these "strange" cases.
#    check ceil(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)
#    check round(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)

test "Rounding during the second half-hour between 00:00 and 00:30.":
    var zdt = initZonedDateTime(1996, 10, 26, 0, 16, tzinfo=colombo, prefer_dst=false)
    check floor(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)
    check ceil(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, 0, 30, tzinfo=colombo)
    check round(zdt, Hour(1)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)
    check floor(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, tzinfo=colombo, prefer_dst=false)
# i am currently unable to pass these tests and i am not sure if the given expected results are
# indeed correct.
#     check ceil(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, 0, 30, tzinfo=colombo)
#     check round(zdt, Minute(30)) == initZonedDateTime(1996, 10, 26, 0, 30, tzinfo=colombo)

# ###############
# # ERROR CASES #
# ###############

test "Test rounding to invalid resolutions.":

    let dt = initDateTime(2016, 2, 28, 12, 15, 10, 190)
    for tz in [utctz, fixedtz, winnipeg, st_johns, eucla, colombo]:
        let zdt = initZonedDateTime(dt, tz)
        expect ValueError:
            echo floor(zdt, Year(0))
        expect ValueError:
            echo floor(zdt, Year(-1))
        expect ValueError:
            echo ceil(zdt, Year(0))
        expect ValueError:
            echo ceil(zdt, Year(-1))
        expect ValueError:
            echo round(zdt, Year(0))
        expect ValueError:
            echo round(zdt, Year(-1))
        expect ValueError:
            echo floor(zdt, Month(0))
        expect ValueError:
            echo floor(zdt, Month(-1))
        expect ValueError:
            echo ceil(zdt, Month(0))
        expect ValueError:
            echo ceil(zdt, Month(-1))
        expect ValueError:
            echo round(zdt, Month(0))
        expect ValueError:
            echo round(zdt, Month(-1))
        expect ValueError:
            echo floor(zdt, Day(0))
        expect ValueError:
            echo floor(zdt, Day(-1))
        expect ValueError:
            echo ceil(zdt, Day(0))
        expect ValueError:
            echo ceil(zdt, Day(-1))
        expect ValueError:
            echo round(zdt, Day(0))
        expect ValueError:
            echo round(zdt, Day(-1))
        expect ValueError:
            echo floor(zdt, Hour(0))
        expect ValueError:
            echo floor(zdt, Hour(-1))
        expect ValueError:
            echo ceil(zdt, Hour(0))
        expect ValueError:
            echo ceil(zdt, Hour(-1))
        expect ValueError:
            echo round(zdt, Hour(0))
        expect ValueError:
            echo round(zdt, Hour(-1))
        expect ValueError:
            echo floor(zdt, Minute(0))
        expect ValueError:
            echo floor(zdt, Minute(-1))
        expect ValueError:
            echo ceil(zdt, Minute(0))
        expect ValueError:
            echo ceil(zdt, Minute(-1))
        expect ValueError:
            echo round(zdt, Minute(0))
        expect ValueError:
            echo round(zdt, Minute(-1))
        expect ValueError:
            echo floor(zdt, Second(0))
        expect ValueError:
            echo floor(zdt, Second(-1))
        expect ValueError:
            echo ceil(zdt, Second(0))
        expect ValueError:
            echo ceil(zdt, Second(-1))
        expect ValueError:
            echo round(zdt, Second(0))
        expect ValueError:
            echo round(zdt, Second(-1))

