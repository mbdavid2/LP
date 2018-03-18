import System.IO

main :: IO ()
main = do
  name <- getWord
  if name /= "*"
      then do
          w <- getWord
          h <- getWord
          putStrLn $ name ++ ": " ++ message (read w :: Float) (read h :: Float)
          main
      else return ()

getWord = do c <- getChar
             if (c == '\n') || (c == ' ')
               then return ""
               else do w <- getWord
                       return (c:w)

message :: Float -> Float -> String
message weight height ..

    | val < 18    = "underweight"
    | val < 25    = "normal weight"
    | val < 30    = "overweight"
    | val < 40    = "obese"
    | otherwise   = "severely obese"
    where val = weight/(height^2)
