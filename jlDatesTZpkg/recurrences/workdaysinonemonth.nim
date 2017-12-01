import ../jlDatesTZ

proc workdaysinonemonth(yr, mt: int): seq[Date] =
  result = @[]
  var curr = initDate(yr, mt, 1)
  var prev = curr
  while true:
   if month(curr) != month(prev):
     break
   if dayofweek(curr) < 6:
     result.add(curr)
   prev = curr
   curr = curr + 1.Day

when isMainModule:
  when defined(js):
    import jsParams
  else:
    import os
  import strutils

  let yr = parseInt(paramStr(1))
  let mt = parseInt(paramStr(2))

  for wd in workdaysinonemonth(yr, mt):
    echo wd, " ", dayabbr(wd)

