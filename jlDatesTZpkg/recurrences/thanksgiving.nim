# Thanksgiving is celebrated on the second Monday of October in Canada 
# and on the fourth Thursday of November in the United States

import ../jlDatesTZ

proc thanksgiving(yr: int): (Date, Date) =
  let firstofoctober = initDate(yr, 10, 1)
  let firstofnovember = initDate(yr, 11, 1)
  
  let firstmondayinoctober = tonext(firstofoctober, 1, same = true)
  result[0] = firstmondayinoctober + Day(7)
 
  let firstthursdayinnovember = tonext(firstofnovember, 4, same = true)
  result[1] = firstthursdayinnovember + Day(7 * 3)


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
    let (canada, us) = thanksgiving(yr + i)
    echo canada, " ", us
