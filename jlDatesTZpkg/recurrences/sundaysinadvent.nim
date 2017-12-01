import ../jlDatesTZ

proc sundaysinadvent(year: int): seq[Date] =
  let christmas = initDate(year, 12, 25)
  let last_advent = toprev(christmas, 7, false)
  let first_advent = last_advent - Day(3 * 7)
  result = @[first_advent]
  for i in 1..2:
    result.add(first_advent + Days(7 * i))
  result.add(last_advent)

when isMainModule:
  when defined(js):
    import jsParams
  else:
    import os
  import strutils
  var count = 1
  var yr = parseInt(paramStr(1))
  if paramCount() > 1:
    count = parseInt(paramStr(2))
  for i in 1..count:
    var line = ""
    for i, advsun in pairs(sundaysinadvent(yr)):
      if i > 0:
        line.add(", ")
      line.add($advsun)
    echo line
    inc(yr)
