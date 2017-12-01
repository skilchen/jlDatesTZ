from math import floor

proc fld[T, U](x: T, y: U): int64 =
  result = int64(floor(float64(x) / float64(y)))

proc yearmonthday(days: int64): tuple[year: int64, month: int64, day: int64] =
  let z = days + 306
  let h = 100 * z - 25
  let a = fld(h, 3652425)
  let b = a - fld(a, 4)
  let y = fld(100 * b + h, 36525)
  let c = b + z - 365 * y  - fld(y, 4)
  let m = `div`(5 * c + 456, 153)
  let d = c - `div`(153 * m - 457, 5)
  result.year = y
  result.month = m
  result.day = d
