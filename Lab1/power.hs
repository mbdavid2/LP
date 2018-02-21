power :: Integer -> Integer -> Integer

power x 0 = 1
power x n = x * power x (n-1)
