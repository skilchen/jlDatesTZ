import ../../jlDatesTZ
import unittest
import tables

# This file is a part of Julia. License is MIT: https://julialang.org/license

let Jan = initDateTime(2013, 1, 1) # Tuesday
let Feb = initDateTime(2013, 2, 2) # Saturday
let Mar = initDateTime(2013, 3, 3) # Sunday
let Apr = initDateTime(2013, 4, 4) # Thursday
let May = initDateTime(2013, 5, 5) # Sunday
let Jun = initDateTime(2013, 6, 7) # Friday
let Jul = initDateTime(2013, 7, 7) # Sunday
let Aug = initDateTime(2013, 8, 8) # Thursday
let Sep = initDateTime(2013, 9, 9) # Monday
let Oct = initDateTime(2013, 10, 10) # Thursday
let Nov = initDateTime(2013, 11, 11) # Monday
let Dec = initDateTime(2013, 12, 11) # Wednesday
let monthnames = ["January", "February", "March", "April",
                "May", "June", "July", "August", "September",
                "October", "November", "December"]
let daysofweek = [2, 6, 7, 4, 7, 5, 7, 4, 1, 4, 1, 3]
let dows = ["Tuesday", "Saturday", "Sunday", "Thursday", "Sunday", "Friday",
            "Sunday", "Thursday", "Monday", "Thursday", "Monday", "Wednesday"]
let daysinmonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

jlDatesTZ.LOCALES["french"] = initDateLocale(
    ["janvier", "février", "mars", "avril", "mai", "juin",
     "juillet", "août", "septembre", "octobre", "novembre", "décembre"],
    ["janv", "févr", "mars", "avril", "mai", "juin",
     "juil", "août", "sept", "oct", "nov", "déc"],
    ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"],
    ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"]
)

test "Name functions":
    for i, dt in pairs([Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]):
        check month(dt) == i + 1
        check monthname(dt) == monthnames[i]
        check monthname(i + 1) == monthnames[i]
        check monthabbr(dt) == monthnames[i][0..2]
        check monthabbr(i + 1) == monthnames[i][0..2]
        check dayofweek(dt) == daysofweek[i]
        check dayname(dt) == dows[i]
        check dayname(dayofweek(dt)) == dows[i]
        check dayabbr(dt) == dows[i][0..2]
        check dayabbr(dayofweek(dt)) == dows[i][0..2]
        check daysinmonth(dt) == daysinmonth[i]

test "Customizing locale":
    check dayname(Nov, locale="french") == "lundi"
    check dayname(Jan, locale="french") == "mardi"
    check dayname(Dec, locale="french") == "mercredi"
    check dayname(Apr, locale="french") == "jeudi"
    check dayname(Jun, locale="french") == "vendredi"
    check dayname(Feb, locale="french") == "samedi"
    check dayname(May, locale="french") == "dimanche"

    check monthname(Jan, locale="french") == "janvier"
    check monthname(Feb, locale="french") == "février"
    check monthname(Mar, locale="french") == "mars"
    check monthname(Apr, locale="french") == "avril"
    check monthname(May, locale="french") == "mai"
    check monthname(Jun, locale="french") == "juin"
    check monthname(Jul, locale="french") == "juillet"
    check monthname(Aug, locale="french") == "août"
    check monthname(Sep, locale="french") == "septembre"
    check monthname(Oct, locale="french") == "octobre"
    check monthname(Nov, locale="french") == "novembre"
    check monthname(Dec, locale="french") == "décembre"

test "Leap Years":
    check isleapyear(initDateTime(1900)) == false
    check isleapyear(initDateTime(2000)) == true
    check isleapyear(initDateTime(2004)) == true
    check isleapyear(initDateTime(2008)) == true
    check isleapyear(initDateTime(0)) == true
    check isleapyear(initDateTime(1)) == false
    check isleapyear(initDateTime(-1)) == false
    check isleapyear(initDateTime(4)) == true
    check isleapyear(initDateTime(-4)) == true

test "Days in Year":
    check daysinyear(2000) == 366
    check daysinyear(2001) == 365
    check daysinyear(2000) == 366
    check daysinyear(2001) == 365

    check daysinyear(initDate(2000)) == 366
    check daysinyear(initDate(2001)) == 365
    check daysinyear(initDateTime(2000)) == 366
    check daysinyear(initDateTime(2001)) == 365

test "Days of week from Monday = 1 to Sunday = 7":
    check dayofweek(initDateTime(2013, 12, 22)) == 7
    check dayofweek(initDateTime(2013, 12, 23)) == 1
    check dayofweek(initDateTime(2013, 12, 24)) == 2
    check dayofweek(initDateTime(2013, 12, 25)) == 3
    check dayofweek(initDateTime(2013, 12, 26)) == 4
    check dayofweek(initDateTime(2013, 12, 27)) == 5
    check dayofweek(initDateTime(2013, 12, 28)) == 6
    check dayofweek(initDateTime(2013, 12, 29)) == 7

test "There are 5 Sundays in December, 2013":
    check daysofweekinmonth(initDateTime(2013, 12, 1)) == 5

test "There are 4 Sundays in November, 2013":
    check daysofweekinmonth(initDateTime(2013, 11, 24)) == 4

test "Day of Week of Month":
    check dayofweekofmonth(initDateTime(2013, 12, 1)) == 1
    check dayofweekofmonth(initDateTime(2013, 12, 8)) == 2
    check dayofweekofmonth(initDateTime(2013, 12, 15)) == 3
    check dayofweekofmonth(initDateTime(2013, 12, 22)) == 4
    check dayofweekofmonth(initDateTime(2013, 12, 29)) == 5

test "Day of Year":
    check dayofyear(2000, 1, 1) == 1
    check dayofyear(2004, 1, 1) == 1
    check dayofyear(20013, 1, 1) == 1
    # Leap year
    check dayofyear(2000, 12, 31) == 366
    # Non-leap year
    check dayofyear(2001, 12, 31) == 365

    check dayofyear(initDateTime(2000, 1, 1)) == 1
    check dayofyear(initDateTime(2004, 1, 1)) == 1
    check dayofyear(initDateTime(20013, 1, 1)) == 1
    # Leap year
    check dayofyear(initDateTime(2000, 12, 31)) == 366
    # Non-leap year
    check dayofyear(initDateTime(2001, 12, 31)) == 365
    # Test every day of a year
    var dt = initDateTime(2000, 1, 1)
    for i in 1..366:
        check dayofyear(dt) == i
        dt = dt + Day(1)

    dt = initDateTime(2001, 1, 1)
    for i in 1..365:
        check dayofyear(dt) == i
        dt = dt + Day(1)

test "Quarter of Year":
    check quarterofyear(initDate(2000, 1, 1))  == 1
    check quarterofyear(initDate(2000, 1, 31))  == 1
    check quarterofyear(initDate(2000, 2, 1))  == 1
    check quarterofyear(initDate(2000, 2, 29))  == 1
    check quarterofyear(initDate(2000, 3, 1))  == 1
    check quarterofyear(initDate(2000, 3, 31))  == 1
    check quarterofyear(initDate(2000, 4, 1)) == 2
    check quarterofyear(initDate(2000, 4, 30)) == 2
    check quarterofyear(initDate(2000, 5, 1)) == 2
    check quarterofyear(initDate(2000, 5, 31)) == 2
    check quarterofyear(initDate(2000, 6, 1)) == 2
    check quarterofyear(initDate(2000, 6, 30)) == 2
    check quarterofyear(initDate(2000, 7, 1)) == 3
    check quarterofyear(initDate(2000, 7, 31)) == 3
    check quarterofyear(initDate(2000, 8, 1)) == 3
    check quarterofyear(initDate(2000, 8, 31)) == 3
    check quarterofyear(initDate(2000, 9, 1)) == 3
    check quarterofyear(initDate(2000, 9, 30)) == 3
    check quarterofyear(initDate(2000, 10, 1)) == 4
    check quarterofyear(initDate(2000, 10, 31)) == 4
    check quarterofyear(initDate(2000, 11, 1)) == 4
    check quarterofyear(initDate(2000, 11, 30)) == 4
    check quarterofyear(initDate(2000, 12, 1)) == 4
    check quarterofyear(initDate(2000, 12, 31)) == 4

    check quarterofyear(initDateTime(2000, 1, 1))  == 1
    check quarterofyear(initDateTime(2000, 1, 31))  == 1
    check quarterofyear(initDateTime(2000, 2, 1))  == 1
    check quarterofyear(initDateTime(2000, 2, 29))  == 1
    check quarterofyear(initDateTime(2000, 3, 1))  == 1
    check quarterofyear(initDateTime(2000, 3, 31))  == 1
    check quarterofyear(initDateTime(2000, 4, 1)) == 2
    check quarterofyear(initDateTime(2000, 4, 30)) == 2
    check quarterofyear(initDateTime(2000, 5, 1)) == 2
    check quarterofyear(initDateTime(2000, 5, 31)) == 2
    check quarterofyear(initDateTime(2000, 6, 1)) == 2
    check quarterofyear(initDateTime(2000, 6, 30)) == 2
    check quarterofyear(initDateTime(2000, 7, 1)) == 3
    check quarterofyear(initDateTime(2000, 7, 31)) == 3
    check quarterofyear(initDateTime(2000, 8, 1)) == 3
    check quarterofyear(initDateTime(2000, 8, 31)) == 3
    check quarterofyear(initDateTime(2000, 9, 1)) == 3
    check quarterofyear(initDateTime(2000, 9, 30)) == 3
    check quarterofyear(initDateTime(2000, 10, 1)) == 4
    check quarterofyear(initDateTime(2000, 10, 31)) == 4
    check quarterofyear(initDateTime(2000, 11, 1)) == 4
    check quarterofyear(initDateTime(2000, 11, 30)) == 4
    check quarterofyear(initDateTime(2000, 12, 1)) == 4
    check quarterofyear(initDateTime(2000, 12, 31)) == 4

test "Day of Quarter":
    check dayofquarter(initDate(2014, 1, 1)) == 1
    check dayofquarter(initDate(2014, 4, 1)) == 1
    check dayofquarter(initDate(2014, 7, 1)) == 1
    check dayofquarter(initDate(2014, 10, 1)) == 1
    check dayofquarter(initDate(2014, 3, 31)) == 90
    check dayofquarter(initDate(2014, 6, 30)) == 91
    check dayofquarter(initDate(2014, 9, 30)) == 92
    check dayofquarter(initDate(2014, 12, 31)) == 92
    check dayofquarter(initDateTime(2014, 1, 1)) == 1
    check dayofquarter(initDateTime(2014, 4, 1)) == 1
    check dayofquarter(initDateTime(2014, 7, 1)) == 1
    check dayofquarter(initDateTime(2014, 10, 1)) == 1
    check dayofquarter(initDateTime(2014, 3, 31)) == 90
    check dayofquarter(initDateTime(2014, 6, 30)) == 91
    check dayofquarter(initDateTime(2014, 9, 30)) == 92
    check dayofquarter(initDateTime(2014, 12, 31)) == 92
