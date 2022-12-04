import Data.List.Split

transform :: [Char] -> Int
transform = points2 . splitOn " "

staticPoints1 :: [[Char]] -> Int
staticPoints1 [_, b] =
    case (b) of
        "X" -> 1
        "Y" -> 2
        "Z" -> 3
        _ -> 0

staticPoints2 :: [[Char]] -> Int
staticPoints2 [a, b] = 
    case (a, b) of 
        ("A", "X") -> 3
        ("B", "X") -> 1
        ("C", "X") -> 2
        ("A", "Y") -> 1
        ("B", "Y") -> 2
        ("C", "Y") -> 3
        ("A", "Z") -> 2
        ("B", "Z") -> 3
        ("C", "Z") -> 1
        (_, _) -> 0

dynamicPoints1 :: [[Char]] -> Int
dynamicPoints1 [a, b] = 
    case (a, b) of 
        ("A", "X") -> 3
        ("B", "X") -> 0
        ("C", "X") -> 6
        ("A", "Y") -> 6
        ("B", "Y") -> 3
        ("C", "Y") -> 0
        ("A", "Z") -> 0
        ("B", "Z") -> 6
        ("C", "Z") -> 3
        (_, _) -> 0

dynamicPoints2 :: [[Char]] -> Int
dynamicPoints2 [_, b] = 
    case (b) of 
        "X" -> 0
        "Y" -> 3
        "Z" -> 6
        _ -> 0

points1 :: [[Char]] -> Int
points1 s = staticPoints1 s + dynamicPoints1 s

points2 :: [[Char]] -> Int
points2 s = staticPoints2 s + dynamicPoints2 s

main = do
    input <- readFile "data/input.txt"
    let games = map transform (endBy "\n" input)
    let result = sum games
    print result
