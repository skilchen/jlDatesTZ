# Election Day is the day set by law for the general elections
# of federal public officials. It is statutorily set as
# "the Tuesday next after the first Monday in the month of November"
# or "the first Tuesday after November 1"

import ../jlDatesTZ

proc electionday(yr: int): Date =
  let firstofnovember = initDate(yr, 11, 1)
  result = tonext(firstofnovember, 2)


when isMainModule:
  when defined(js):
    import jsParams
  else:
    import os
  import strutils

  let yr = parseInt(paramStr(1))
  var count = 1
  if paramCount() > 1:
    count = parseInt(paramStr(2))

  for i in 0..count-1:
    echo electionday(yr + i), if (yr + i) mod 4 == 0: " presidential" else: ""

