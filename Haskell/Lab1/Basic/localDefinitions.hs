prodLet n m =
    if n == 0 then 0
    else let x = div n 2
             y = mod n 2
         in if y == 0 then 2 * (prodLet x m)
            else (prodLet (n-1) m) + m

prodWhere n m =
    if n == 0 then 0
    else if y == 0 then 2 * (prodWhere x m)
         else (prodWhere (n-1) m) + m
    where x = div n 2
          y = mod n 2
