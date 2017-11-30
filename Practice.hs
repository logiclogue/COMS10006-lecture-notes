import Data.List

fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

length' :: [Integer] -> Integer
length' []     = 0
length' (x:xs) = 1 + length' xs

drop' :: Integer -> [a] -> [a]
drop' 0 xs     = xs
drop' n []     = []
drop' n (x:xs) = drop' (n - 1) xs

odd' :: Integer -> Bool
odd' 0 = False
odd' n = not . odd $ n - 1

data Suit = Hearts | Diamonds | Clubs | Spades
          deriving Show

data Face = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
          deriving (Show, Eq)

data Card = Joker
          | Card (Face, Suit)
          deriving (Show)

snap :: Card -> Card -> String
snap (Card (a, _)) (Card (b, _))
    | a == b    = "SNAP"
    | otherwise = "..."

removeJokers :: [Card] -> [Card]
removeJokers []         = []
removeJokers (Joker:xs) = removeJokers xs
removeJokers (x:xs)     = x : removeJokers xs

alpha :: Integer -> Char
alpha 1 = 'a'
alpha x = succ . alpha $ x - 1

sprinkle :: a -> [a] -> [[a]]
sprinkle x [] = [[x]]
sprinkle x xs = zipWith (\y z -> y ++ (x : z)) (inits xs) (tails xs)

applies :: [(a -> b)] -> [a] -> [b]
applies [] []         = []
applies (f:fs) []     = []
applies [] (x:xs)     = []
applies [f] (x:xs)    = f x : applies [f] xs
applies (f:fs) (x:xs) = (f x : (applies [f] xs)) ++ (applies fs (x:xs))

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = (last xs) : (reverse (init (x:xs)))

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x xs -> if p x then (x:xs) else xs) []

group' :: Eq a => [a] -> [[a]]
group' = foldr f [[]] where
    f x [[]] = [[x]]
    f x (xs:xss)
        | x == head xs = ((x:xs):xss)
        | otherwise    = [x]:(xs:xss)

transpose' :: [[a]] -> [[a]]
transpose' = foldr cons empty where
    cons [] yss          = yss
    cons (x:xs) []       = [x] : (cons xs [])
    cons (x:xs) (ys:yss) = (x:ys) : (cons xs yss)
    empty                = []
