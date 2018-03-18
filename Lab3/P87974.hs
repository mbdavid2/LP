import System.IO

main :: IO ()
main = do
  name <- getLine
  putStrLn $ (f name)

f :: [Char] -> [Char]
f [] = "Bye!"
f (x:xs)
    | x == 'a' || x == 'A'  = "Hello!"
    | otherwise             = "Bye!"
