# Package

version       = "0.1.0"
author        = "skilchen"
description   = "a almost complete translation of julias Dates module to Nim with some TimeZone support"
license       = "MIT"

bin           = @["jlDatesTZ"]


# Dependencies
requires "nim >= 0.17.3"
requires "zip >= 0.1.1"
requires "struct >= 0.1.1"


task tests, "Run the jlDatesTZ tests":
  exec "nim c -r jlDatesTZpkg/tests/alltests"

