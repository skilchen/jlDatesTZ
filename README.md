# jlDatesTZ
A translation of Dates from julias standard library to Nim.

Most of the basic functionality of julias Dates has been translated to Nim with two notable exceptions:
- jlDatesTZ has no implementation of vectorized operations
- for parsing/formatting dates/times a simplified version of strptime/strftime has been implemented. In the jlDatesTZ version strptime uses the parsed timezone offset to build a timezone definition with a fixed offset, if you pass `zoned=true` as a parameter to the strptime call. strptime returns a variant object containing either a DateTime or a ZonedDateTime instance depending on the `zoned` parameter.

Some of the TimeZone functionality inspired by the TimeZones package from julialang has been included. The code to deal with the binary files from the IANA timezone db has been taken from my [ZonedDateTime](https://github.com/skilchen/ZonedDateTime) module.

To see what is possible with jlDates please take a look at the tests. The official [documentation](https://docs.julialang.org/en/stable/stdlib/dates/) from julia is also useful to get an overview. The main feature of the design of  julia's Base.Dates module is that dates/times are essentially wrappers around int64 values. No broken down calendar fields are stored. They are computed whenever needed for calculations or presentation purposes. This design essentially enables very fast date/time arithmetic.
Unfortunately i was not capable enough to get the same speed in Nim as julia gets. But jlDates is still reasonably fast. Date/Time arithmetic is much faster with jlDates than with the times module from Nims standard library.

