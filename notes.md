## Functional Programming Definition

- Programming with *values* rather than *actions*

## Statements and Expressions

- Expression language more powerful -> code simpler to understand

## Programming Environment

```
  Editor     Compiler   Execution
Human -> Source -> Binary -> Process
```

## Functional Programming

- It's about programming with functions as values
- This emphasis leads to programs that are usually concise, precise, and
  reasonable
- Concise: programs are short
- Precise: they do what they say they do and no more
- Reasonable: you can use equational reasoning

### Origins

- The origins of functional programming are generally agreed to be the lambda
  calculus
- This was introduced by Alonso Church, in the 1930s
- Church-Turing thesis showed that the lambda calculus is Turing complete

- Haskell was originally conceived in ~1990
- Haskell was officially released in 1998
- Haskell was based on another language called Miranda

### Lambda Calculus

- Lambda calculus is made up of 3 components:
    - Variables (x)
    - Lambda abstractions (\x . M)
    - Application (M N)
- Example: (\x . x) 3 = 3
- We will study Haskell as a model language that implements the lambda calculus

## Haskell Example

```
fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
```

- `fib` is the function name
- `Int -> Int` is the type signature
- `fib 0` and `fib 1` is 'pattern matching'
- `fib (n - 2)` is recursion
- `fib` is a recursive definition

## Plain-Old-Datatypes (PODS)

- Haskell has a number of built in datatypes
    - `5 :: Int` or `5 :: Integer`
        - `Int` is fast, but inaccurate
        - `Integer` is slower, but has infinite precision
    - `True :: Bool`
    - `False :: Bool`
    - `3.14 :: Double`
    - `'a' :: Char`
    - `"Hello" :: String`

Each of these definitions are of the form:

- `5 :: Int`
    - This can mean that `5 ∊ Int`

- Every value in Haskell has a principal type
    - This means that there exists a, in most general type, such that all other
      types are an instance of the principal type

## Functions

Functions are mappings from values to values

Mathematics: `f(x) = x²`

Haskell:

```
f :: Integer -> Integer
f x = x * x
```

- `x` here is the parameter
- `5` when passed in, is the argument

## Evaluation

```
square :: Int -> Int
square x = x * x
```

```
two :: Int -> Int
two n = 2
```

Evaluation is about substitution

- `square 5`
    - = { def `square` }
- `5 * 5`
    - = { def `*` }
- `25`

There are many ways of evaluating expressions but there are two main ones

- Lazy evaluation (normal order) ← outer most first
- Eager evaluation (applicative order) ← inner most first

### Example 1

```
two (square 3)
```

Eager:

```
two (square 3)
-- = { def square }
two (3 * 3)
-- = { def * }
two 9
-- = { def two }
2
```

Lazy:

```
two (square 3)
-- = { def two }
2
```

### Example 2

```
square (3 + 1)
```

Eager:

```
square (3 + 1)
-- = { def + }
square 4
-- = { def square }
4 * 4
-- = { def * }
16
```

Lazy: (top down, left to right)

```
square (3 + 1)
-- = { def square }
(3 + 1) * (3 + 1)
-- = { def + }
4 * (3 + 1)
-- = { def + }
4 * 4
-- = { def * }
16
```

### Which evaluation strategy should we use?

The Church-Rosser theorem says:

1. If one evaluation terminates when applied to a given expression, then normal
   order will terminate
2. If two evaluations terminate for a given expression, then they will agree on
   the result

### Example

```
infinity :: Integer
infinity = 1 + infinity
```

Let's evaluate `two infinity` and beyond

Lazy:

```
two infinity
-- = { def two }
2
```

Eager:

```
two infinity
-- = { def infinity }
two (1 + infinity)
-- = { def infinity }
two (1 + (1 + infinity))
```

- One evaluation terminates, in this situation
    - It is normal order (lazy evaluation) as the Church-Rosser theorem states

## Lists

Example:

`[3, 1, 2] :: [Integer]`

- All elements have the same type
- *Homogeneous* list (each element has the same type)
- Infinite lists are fine in Haskell

```
nats :: [Integer]
nats = [0..]
```

`[5..10]` = `[5, 6, 7, 8, 9, 10]`

- Lists are always constructed in 1 of 2 ways
    - Empty lists `[]`
    - Consing (which means attaching an element of the list) `5 : [10]` (`(:) :: a -> [a] -> [a]`)
        - `[3, 1, 4]`
        - = `3 : [1, 4]`
        - = `3 : 1 : [4]`
        - = `3 : 1 : 4 : []`
    - As a guide, always consider `[]` and `(:)` when defining functions and
      lists

# Definitions

## `head`

- The `head` function returns the first element of the list
- `head :: [a] -> a`
- `head (x:xs) = x`
- Don't use `head` on an empty list

## `tail`

- The `tail` function returns the list after the first element
- `tail :: [a] -> [a]`
- `tail (x:xs) = xs`
- Don't use `tail` on an empty list

## `length`

- The `length` function return the length of given list
- `length :: [a] -> Integer`
- `length []     = 0`
- `length (x:xs) = 1 + length xs`

- Note: Always try to align the `=`

## `isEmpty`

- The `isEmpty` function which returns to see if a list is empty
- `isEmpty :: [a] -> Bool`
- `isEmpty []     = True`
- `isEmpty (x:xs) = False`

## `isSingle`

- `isSingle :: [a] -> Bool`
    - `isSingle []     = False`
    - `isSingle [x]    = True` alternatively `isSingle (x:[]) = True`
    - `isSingle (x:xs) = False` alternatively `isSingle xs    = False`
      or better `isSingle _ = False`
- Alternatively:
    - `isSingle []     = False`
    - `isSingle (x:xs) = isEmpty cs`

## `take`

- This function `take`s a number of elements
- `take :: Int -> [a] -> [a]`
- `take 0 _      = []`
- `take n []     = []`
- `take n (x:xs) = x : take (n - 1) xs`

## `drop`

- `drop :: Int -> [a] -> [a]`
- `drop 0 xs     = xs`
- `drop n []     = []`
- `drop n (x:xs) = drop (n - 1) xs`

## `++`

- We also make use of a function that appends two lists together
- `(++) :: [a] -> [a] -> [a]`
- `[]     ++ ys = ys`
- `(x:xs) ++ ys = x : (xs ++ ys)`

## Pattern Guards and `filter`

- `filter :: (a -> Bool) -> [a] -> [a]`
- `filter p []     = []`
- `filter p (x:xs) = f p x then x : filter p xs else filter p xs`
    - This version of `filter` used an `if` `then` `else` conditional
    - A pattern guard can make things a bit nicer:

- `filter :: (a -> Bool) -> [a] -> [a]`
- `filter p []     = []`
- `filter p (x:xs) | p x = x : filter p xs`
                - `| otherwise = filter p xs`

## `otherwise`

- `otherwise :: Bool`
- `otherwise = True`

## `odd`

- `odd :: Integer -> Bool`
- `odd 0 = False`
- `odd n = not . odd $ n - 1`

- Pattern guards must not be confused with constructor alternatives
    - `data Day = Monday | Tuesday | Wednesday | ...`
    - `data Bool = True`
                `| False`

## Currying

- Every function takes in 1 argument and outputs 1 value

- `add :: (Int, Int) -> Int`
- `add (x, y) = x + y`

- To use this, we can write `add (3, 4)`

- `plus :: Int -> Int -> Int` or `plus :: Int -> (Int -> Int)`
- `plus x y = x + y`

- This means that we can partially apply functions
- For instance, we might want this function:

- `plusTwo :: Int -> Int`
- `plusTwo y = 2 + y`

- Better:

- `plusTwo :: Int -> Int`
- `plusTwo = plus 2`

- Consider the type `plus 2 :: Int -> Int`

- We can convert between add and plus by using a method called currying
    - `curry add = plus`
    - `add = uncurry plus`

## Inhabitants

- Inhabitants of `Bool` are `True` and `False`

## Currying

- We can implement `curry` and `uncurry`
    - `curry :: ((a, b) -> c) -> (a -> b -> c)`
    - `curry f x y = f (x, y)`
- The reason `x:a` and `y:b` can be put on the left-hand side of `=` is that we
  can rewrite the type of curry
- We could give a different definition using lambda
    - `curry f = \x -> (\y -> f (x, y))`
    - `curry f = \x y -> f (x, y)`

## Extensionality

- Extensionality says that two functions `f` and `g` are equal if they agree
  on their output given any input
    - `f = \x -> f x`

## Uncurrying

- The inverse of curry is uncurry
- `uncurry :: (a -> b -> c) -> (a, b) -> c`
- `uncurry g = \(x, y) -> g x y`
- or
- `uncurry g (x, y) = g x y`

- Let's try to show that add and plus are equivalent
- We want to show that `plus x y` = `add (x, y)`
- Proof:
    - `plus x y`
    - = { def plus }
    - `x + y`
    - = { def add }
    - `add (x, y)`

- Another interesting calculation converts the definition of `plus`
- `plus x y = x + x`
- ⇔ { extensionality }
- `plus x = \y -> x + y`
- ⇔ { extensionality }
- `plus = \x -> \y -> x + y`
- ⇔ { syntactic sugar }
- `plus = \x y -> x + y`

## Lambdas

- A lambda introduces a function with no name
- The syntax is this:
    - `\_input_ -> _output_`
    - You can think of this as a black box
    - `\x -> (x + 1) ** 2`
    - Alternative notation for `\x -> f x` in `x |-> f x` or `\x . f x`

## Function Composition

- Function composition is all about putting functions together
- Plugging the output of one function into the input of another

- `f x = (x ** 2) + 3`
- This is the combination of plus 3 and square
    - Where
    - `plus :: Int -> Int -> Int`
    - `plus x y = x + y`
    - `square :: Int -> Int`
    - `square x = x * x`
- We can define `f` as follows
- `f x = plus 3 (square x)`
- This can also be written as a single function applied to `x`
- `f x = (plus 3 . square) x`
- `f = plus 3 . square`

- `g x = (x + 5) ** 2`
- `g = square . plus 5`
- = {Leibniz's law}

- `g = square . plus 5`
- ⇒ {Leibniz's law}
- `g x = (x + 5) ** 2`

- `$ x` is a function that applies `x`
- Pronounced "ap"
- Defined as
    - `($) :: (a -> b) -> a -> b`
    - `f $ x = f x`

- Composition `(.)` is also a function
- It is defined as
    - `(.) :: (b -> c) -> (a -> b) -> (a -> c)`
    - `(g . f) x = g (f x)`

## Leibniz's Law

- This law is used all the time in algebraic manipulations
    - `x = y`
    - ⇔ { Leibniz's law }
    - `f x = f y`

## Maps

- A map takes in a function `f` and a list `xs`, and produces a list where each
  element, in `xs`, is the result of `f` applied to each element
- For instance
    - `[0, -2, 1, -2, 2]`
    - `map (+ 3) [0, -2, 1, -2, 2]`
    - `[3, 1, 4, 1, 5]`

- The `map` function is defined as follows
    - `map :: (a -> b) -> [a] -> [b]`
    - `map f [] = []`
    - `map f (x:xs) = f x : map f xs`

### Map Example

- `alpha :: Int -> Char`
- `alpha 1 = 'a'`
- `alpha 2 = 'b'`
- `...`
- `alpha 26 = 'z'`

- Better definition for alpha
    - `alpha :: Int -> Char`
    - `alpha 1 = 'a'`
    - `alpha succ . alpha $ x - 1`

- Let's calculate the result of `map alpha [1, 3, 5]`
- `map alpha [1, 3, 5]`
- = { def (:) }
- `map alpha (1 : [3, 5])`
- = { def map }
- `alpha 1 : map alpha [3, 5]`
- = { def alpha }
- `'a' : map alpha [3, 5]`
- = { def (:) }
- `'a' : map alpha (3 : [5])`
- = { def map }
- `'a' : alpha 3 : map alpha [5]`
- = { def alpha }
- `'a' : 'c' : map alpha [5]`
- = { def (:) and map }
- `'a' : 'c' : alpha 5 : map alpha []`
- = { def alpha }
- `'a' : 'c' : 'e' : map alpha []`
- = { def map }
- `'a' : 'c' : 'e' : []`
- = { def (:) }
- `['a', 'c', 'e']`

## Side Note

- Use `=` when finding the definition
- Use `⇔` when showing that the expression is equivalent
    - e.g.
        - Extensionality
        - Syntactic sugar
- Use `⇒` when evaluating with Leibniz's Law

## List Comprehensions

- List comprehensions provide useful syntax for building lists
- Might want to square all the odd numbers
    - `[x * x | x <- nats, odd x]`
        - `|` means "such that"
        - On the right side of the `|` are the conditions
        - This assumes that `nats = [0..]` and `odd :: Int -> Bool` that is true
          when the value given is odd
        - The expression is syntactic sugar for
            - `map square (filter odd nats)`

## Operators vs Functions

- Operators are made up of symbols like `+`, `*`, `/`, etc
    - For full syntactic details, look at the "Haskell Report"

- Functions start with lowercase letters, followed by other alphanumeric
  characters, or "primes" (`'` which are just apostrophes)
- Operations are infix by default, which means that we use them between two
  values
    - `x + y` ← infix
- Functions are prefix by default, so we write them before the arguments
    - `plus 3 7` ← prefix
- An operator can be made prefix by surrounding it by parenthesis
    - `x + y = (+) x y`
- This explains why the type of addition is
    - `(+) :: Int -> Int -> Int`
- A function can be made infix by surrounding with back ticks \`\`
    - `mod 3 5 = 3 \`mod\` 5`

## Sectioning

- Sometimes it is useful to supply only 1 argument to a binary operator

- For instance, here are some ways of defining `plusOne`

- `plusOne :: Int -> Int`
- `plusOne x = 1 + x`

- Same as writing

- `plusOne :: Int -> Int`
- `plusOne = (1 +)`

- Alternatively, because `+` is commutative

- `plusOne :: Int -> Int`
- `plusOne = (+ 1)`

- We could write as follows:

- `(x Ø) = \y -> x Ø y`
- also
- `(y Ø) = \x -> x Ø y`

- Sectioning does not work for function that are in infix form, so `(\`mod\` 5)`
  is illegal
- However, functions can be partially applied, given:
    - `mod :: Int -> Int -> Int`
    - `mod 3 = \y -> mod 3 y`

## Unification Errors

- A type error when the given parameter is not the same as the parameter asked
  for

# Recursion Schemes - Fold

- Recursion can be dangerous
    - We use programming language constructs to control it
- We have
    - `goto` - Dangerous but powerful
    - `while`
    - `for`
    - Fold - Safe but predictable

- A fold takes a list and catastrophically works with it to produce a final
  value
    - Technically they're called "catamorphisms"

- A fold over a list can be demonstrated by the sum function
    - `1 : 2 : 3 : 4 : []`
    - `  ↓   ↓   ↓   ↓ ↓`
    - `1 + 2 + 3 + 4 + 0`

- A fold starts on the right hand-side of a list and reduces it by first
  modifying the empty list [] and then adding elements to the solution by
  transforming the cons, (:)
- We need to product two ingredients
    - A way of dealing with []
    - A way of dealing with (:)
- Usually we have `k :: b` for replacing `[]` and `f :: (a -> b -> b)` for
  replacing `(:)`

- `foldr :: (a -> b -> b) -> b -> [a] -> b`
- `foldr f k [] = k`
- `foldr f k (x:xs) = f x (foldr f k xs)`

- The function `sum` can be written without a `foldr`, as follows
    - `sum :: [Int] -> Int`
    - `sum [] = 0`
    - `sum (x:xs) = x + sum xs`

- As a fold, we're going to do the following
    - `sum :: [Int] -> Int`
    - `sum xs = foldr (+) 0 xs`

- This is equivalent to the following
    - `sum :: [Int] -> Int`
    - `sum = foldr (+) 0`
    - Due to extensionality

## Folding a list

- `sum [3, 1, 4]`
- = { def `sum` }
- `foldr (+) 0 [3, 1, 4]` ← We will skip the syntactic sugar steps that desuger
  `[3, 1, 4]` into `3 : 1 : 4 : []`
- = { syntactic sugar }
- `foldr (+) 0 (3 : 1 : 4 : [])`
- = { def `foldr` }
- `(+) 3 (foldr (+) 0 (1 : 4 : []))`
- = { def `foldr` }
- `(+) 3 ((+) 1 (foldr (+) (4 : [])))`
- = { def `foldr` }
- `(+) 3 ((+) 1 ((+) 4 (foldr (+) ([]))))`
- = { def `foldr` }
- `(+) 3 ((+) 1 ((+) 4 0))`
- = { def `(+)` }
- `(+) 3 ((+) 1 4)`
- = { def `(+)` }
- `(+) 3 5`
- = { def `(+)` }
- `8`

## Inductive proof

- Prove: `sum = foldr (+) 0`

### Base case

- `sum []`
- = { def `sum` }
- `0`
- = { def `foldr` }
- `foldr (+) 0`

### Inductive case

- `sum (x:xs)`
- = { def `sum` }
- `x + sum xs`

- `foldr (+) 0 (x:xs)`
- = { def `foldr` }
- `(+) x (foldr (+) 0 xs)`
- = { rearranging }
- `x + (foldr (+) 0 xs)`
- = { def `sum` }
- `x + sum xs`
- `sum xs = foldr (+) 0 xs`
- = { extensionlity }
- `sum = foldr (+) 0`

## Product

- `foldr` is a general scheme, and we can use it to define many other functions

- `product [1..4] = product (1 : 2 : 3 : 4 : [])`
- `                          1 * 2 * 3 * 4 * 1`

- `product :: [Int] -> Int`
- `product = foldr (*) 1`

## Length

- `length :: [a] -> Int`

- `length [1, 2, 3]`
- `length (1 : 2 : 3 : [])`
- `        (+ 1) (+ 1) (+ 1) 0`
- `length = foldr (const (+ 1)) 0`

# Monoids

- A monoid is an operation that is associative and has a neutral element
- More generally, we can think of a monoid as an operation *XOR symbol* with a
  neural element ∅
    - Such that the following laws hold
        - x *XOR symbol* ∅ = x (∅ = right-identity)
        - ∅ *XOR symbol* y = y (∅ = left-identity)
        - x *XOR symbol* (y *XOR symbol* z) = (x *XOR symbol* y) *XOR symbol* z
          (*XOR symbol* = associative)

### Examples

- `+` is a monoid
    - It's associative
    - It's neural element is 0

- `+`
    - Natural numbers
    - 0
    - Sum
- `*`
    - Positive natural numbers
    - 1
    - Product
- `∨`
    - Bool
    - False
    - Or
- `∧`
    - Bool
    - True
    - And
- Union
    - Pairs
    - ∅
    - Union
- Intersection
    - Pairs
    - A
    - Intersection
- Maximum
    - [-infinity, infinity]
    - -infinity
    - Maximum
- Minimum
    - [-infinity, infinity]
    - infinity
    - Minimum
- Function composition (`.`)
    - x → y
    - id
- `++`
    - [a]
    - []
    - `concat`

## Type Classes

- A type class defines a family of types, all related by their operations
- Type classes are usually defined in terms of their operations and the laws
  that the operations must satisfy

- For monoids, we introduce a new type class as follows

- `class Monoid m where`
    - `mappend :: m -> m -> m` - (*XOR symbol*)
    - `mempty  :: m          ` - ( ∅ )

- A valid instance of the Monoid class respects the Monoid laws

- Here is how we would write an instance of this class

```
instance Monoid Int where
    mappend = (+)
    mempty  = 0
```

- This allows us to define a generic operation like `crush`

- `crush :: Monoid m => [m] -> m`
- `crush = foldr mappend mempty`

- The problem with the monoid instance above is that it is only valid for `Int`,
  and we cannot have another instance for `Int`
- For instance, we might want to have multiplication as the monoid
- To solve this, we will use a new type constructor
- This introduces a new type that behaves exactly the same as `Int`
    - But it is of a different type

## Newtypes

- One word!
- To introduce a newtype in Haskell, we write

- `newtype PInt = PInt Int`

- `newtype` is a bit like `data`, except it states that `Int` is isomorphic to
  `PInt`

- The 'isomorphic to' symbol is ~==, if you know what I mean?

- To convert from `Int` to a `PInt`

- `toPInt :: Int -> PInt`
- `toPInt x = PInt x`
- This is completely redundant, since we can use the `PInt` constructor

- To convert the other way around

- `fromPInt :: PInt -> Int`
- `fromPInt (PInt x) = x`

- Because we have that `PInt` is a newtype of `Int`, we can assume that
    - `toPInt . fromPInt = id`
    - `fromPInt . toPInt = id`

- The functions `toPInt` and `fromPInt` witness that `PInt` is isomorphic to
  `Int`

- An alternative notations for newtype automatically introduces the
  deconstructor

- `newtype PInt = PInt { unPInt :: Int }`
- In this defintion, `toPInt = PInt` and `fromPInt = unPInt`

- To use this newtype for the product monoid, we treat it like any other type

```
instance Monoid PInt where
    mappend (PInt x) (PInt y) = PInt (x * y)
    mempty = PInt 1
```

- The following `crush` will have the right type
- `crush :: [PInt] -> PInt`
- However, we really wanted a function of type
    - `[Int] -> Int`
- We will achieve this as follows
- `[Int]` becomes (via `map PInt`) `[PInt]` becomes (via `crust`) `PInt` becomes
  (via the deconstructor) `Int`
    - `unPInt . crush . map PInt`

- There are lots of type classes in Haskell

```
class Eq a where
    (==) :: a -> a -> Bool
```

- For instance, equality on `Bool` is as follows

```
instance Eq Bool where
    True == True = True
    False == False = True
    _ == _ = False
```
- Haskell is able to derive the `Eq` constraint with the `Eq` type class by
  itself
- For instance, we might have had this in the prelude instead

```
data Bool = True | False
    deriving Eq
```

- Another useful type class is `Num`
- Which allows us to write numbers

```
class Num a where
    (+) :: a -> a -> a
    (-) :: a -> a -> a
    (*) :: a -> a -> a
    negate :: a -> a
    abs :: a -> a
    signum :: a -> a
    fromInteger :: Integer -> a
```

- This is implemented for `Int`, `Integer`, `Float`, and `Double`

## Show

- Additionally there is a class called `Show`

```
class Show a where
    show :: a -> String
```

- It is conventional, but not required, that `Show` produces the same output as
  the constructors but as a string

```
instance Show Bool where
    show True = "True"
    show False = "False"
```

## Deriving Folds

- The definitions for folds can usually be derived in a fairly automatic
  process, starting from an example

- One task is to define `group` as a `foldr`
    - `group :: Eq a => [a] -> [[a]]`
- For instance
    - `group [1, 2, 2, 3] = [[1], [2, 2], [3]]`
- It has the property that `concat (group xs) = xs`

- To define `group` as a `foldr`, we can do this by example
- `foldr f k (1 : 2 : 2 : 3 : [])`
- `       (f 1 (f 2 (f 2 (f 3   k )`
- `f 3 k             = [[3]]`
- `f 2 [[3]]         = [[2], [3]]`
- `f 2 [[2], [3]]    = [[2, 2], [3]]`
- `f 1 [[2, 2], [3]] = [[1], [2, 2], [3]]`

- The type of `f` is clear from the definition of `foldr`

```
f :: Eq a => a -> [[a]] -> [[a]]
f x ((y:ys):yss) 
    | x == y    = (x : y : ys) : yss
    | otherwise = [x] : (y : ys) : yss
f x []          = [[x]]
```

## Maybe

- Some data types contain other values
    - An example is lists
- Another example is `Maybe`

```
data Maybe a
    = Nothing
    | Just a
```

- This is parameterised by a, which means that we have defined a family of types
    - A type for each type

- For example
    - `Maybe Int`
    - `Maybe Bool`
    - `Maybe [Int]`
    - `Maybe (Maybe Int)`
    - etc.

- It maybe useful to change the contents of a `Maybe` by applying a function
- This is similar to `map` for lists

```
mapMaybe :: (a -> b) -> Maybe a -> Maybe b
mapMaybe f Nothing = Nothing
mapMaybe f (Just x) = Just (f x)
```

- This datatype allows us to define safe versions of functions that may not
  return promised values
- For instance, consider
    - `head :: [a] -> a`
    - `tail :: [a] -> [a]`

- `headMay :: [a] -> Maybe a`
- `headMay [] = Nothing`
- `headMay (x:xs) = Just x`

- `tailMay :: [a] -> Maybe [a]`
- `tailMay [] = Nothing`
- `tailMay (x:xs) = Just xs`

# Trees

- There are many different shaped trees
- Arguably lists and maybe values are trees too
- Two main tree types are `Tree` and `Bush`

- A `Tree` has values as its leaves and forks into two
- Made of forks and leaves

- A `Bush` has values at its nodes but not at its tips

- In Haskell, we define the structures as follows

```
data Tree a
    = Leaf a
    | Fork (Tree a) (Tree a)
```

```
data Bush a
    = Tip
    | Node (Bush a) a (Bush a)
```

## Tree Example

- `Fork (Fork (Leaf 3) (Leaf 4)) (Leaf 5)`

## Bush Example

- `Node (Node Tip 4 Tip) 3 Tip`

## Mappings

- We might want to transform the contents of a `Tree` or a `Bush` by using a
  function
- This is the same idea as `map` for lists, or `mapMaybe` for `Maybe`

```
mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f (Leaf x) = Leaf (f x)
mapTree f (Fork l r) = Fork (mapTree f l) (mapTree f r)
```

```
mapBush :: (a -> b) -> Bush a -> Bush b
mapBush f Tip = Tip
mapBush f (Node l x r) = Node (mapBush f l) (f x) (mapBush f r)
```

# Functor

- A functor is a structure whose contents can be changed
- Notice that lists, maybes, trees, and bushes all have something in common
    - They have `map` functions

- `map :: (a -> b) -> [a] -> [b]`
- `mapMaybe :: (a -> b) -> Maybe a -> Maybe b`
- `mapTree :: (a -> b) -> Tree a -> Tree b`
- `mapBush :: (a -> b) -> Bush a -> Bush b`

- All of these maps are generalised into `fmap`

- `fmap :: Functor f => (a -> b) -> f a -> f b`

- The `fmap` function is a member of the `Functor` type class

```
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

## Functor Laws

- There are two laws associated to the `Functor` class

1. Functor identity
    - `fmap id = id`
2. Functor composition
    - `fmap g . fmap f = fmap (g . f)`

## Instances

- So since we have a type class, there should be instances of this, one for each
  of the relevant types

```
instance Functor [] where
    fmap f [] = []
    fmap f (x:xs) = f x : fmap f xs
```

- Or alternatively
    - `fmap = map`

- Similarly for the others

```
instance Functor Tree where
    fmap f (Leaf x) = Leaf (f x)
    fmap f (Node l r) = Node (fmap f l) (fmap f r)
```

- Or, alternatively
    - `fmap = mapTree`

## Finding Elements

- Here is a function that tells you if an element is present in a list

```
elem :: Eq a => a -> [a] -> Bool
elem x [] = False
elem x (y:ys)
    | x == y    = True
    | otherwise = elem x ys
```

- Finding the element takes
    - At best, 1 == operations
    - At worst, n == operations (if the list is of length n)
    - On average, something like n / 2 steps
    - We write this as 'O(n)' (pronounced: "big O of n")

- We will try to improve this by using a `Bush` instead
- To do this, we create an ordered bush
    - Where elements to the left are smaller than the elements to the right
- We build a sorted bush by repeatedly inserting

```
insert :: Ord a => a -> Bush a -> Bush a
insert x Tip = Node Tip x Tip
insert x (l y r)
    | x < y  = Node (insert x l) y r
    | x <= y = Node l y (insert x r)
```

- Now that we know how to insert a single element into a sorted bush
- We have everything we need to convert a list of elements into a bush

```
toBush :: Ord a => [a] -> Bush a
toBush = foldr insert Tip
```

- Now we can implement an algorithm to see whether an element is in the bush

```
elemBush :: Ord a => a -> Bush a -> Bool
elemBush x Tip = False
elemBush x (Node l y r)
    | x < y = elemBush x l
    | x == y = True
    | x > y = elemBush x r
```

- If the bush that we have created is fully balanced and contains n elements
    - Then we have at worse log₂ n comparisons
    - Complexity is O(log n) under these conditions

# Generic Folding

- The fold function for lists captured many useful algorithms
- We can define similar functions for other data types
    - Such as `Maybe a`, `Tree a`, and `Bush a`

- Where does the structure of the `foldr` function come from?

- `foldr :: (a -> b -> b) -> b -> [a] -> b`

- Looking at the signature, the last part is fixed
- We might ask ourselves where `(a -> b -> b)` and `b` come from
- Let's see the structure of lists
- There are two constructors
    - `[]  :: [a]`
    - `(:) :: a -> [a] -> [a]`

- These two constructors correspond to the two arguments of `foldr`
    - Where `[a]` has been replaced with `b`
- Let's redefine `foldr` where we name the variables something that reminds us
  of this fact

```
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr cons empty [] = empty
foldr cons empty (x:xs) = cons x (foldr cons empty xs)
```

## Folding Maybes

- It turns out that we can also fold a `Maybe`

- First, we look at the structure of `Maybe`
    - `data Maybe a = Noting | Just a`
    - This has introduced the two constructor functions called `Nothing` and
      `Just`

- The types of these functions are
    - `Nothing :: Maybe a`
    - `Just    :: a -> Maybe a`

- Now we can define the fold maybe

```
foldMaybe :: b -> (a -> b) -> Maybe a -> b
foldMaybe nothing just Nothing = nothing
foldMaybe nothing just (Just x) = just x
```

## Folding Trees

- So now lets apply this to folding a `Tree`

```
data Tree a = Fork (Tree a) (Tree a)
            | Leaf
```

- The type of these constructors is
    - `Leaf :: a -> Tree a`
    - `Fork :: Tree a -> Tree a -> Tree a`

- So now we use these signatures where `Tree a :: b` for the signature of our
  fold

```
foldTree :: (a -> b) -> (b -> b -> b) -> Tree a -> b
foldTree leaf fork Leaf x = leaf x
foldTree leaf fork (Fork l r) =
    fork (foldTree leaf fork l) (foldTree leaf fork r)
```

## Folding Bushes

```
data Bush a = Tip
            | Node (Bush a) a (Bush a)
```

- Types of the constructors are
    - `Tip :: Bush a`
    - `Node :: Bush a -> a -> Bush a -> Bush a`

```
foldBush :: b -> (b -> a -> b -> b) -> Bush a -> b
foldBush tip node Tip = tip
foldBush tip node (Node l x r) =
    node (foldBush tip node l) x (foldBush tip node r)
```

## Counting Number of Elements

- Suppose we want to find the number of elements inside of a `Bush`
- Then this can be defined with a fold

```
sizeBush :: Bush a -> Int
sizeBush = foldBush tip node where
    tip :: Int
    tip = 0
    node :: Int -> a -> Int -> Int
    node l x r = l + 1 + r
```

## Height of the Bush

- Now we try to find the height of the `Bush`

```
heightBush :: Bush a -> Int
heightBush = foldBush tip node where
    tip :: Int
    tip = 1
    node :: Int -> a -> Int -> Int
    node l x r = 1 + max l r
```

## Bush to List

- A harder example is `fromBush`

```
fromBush :: Bush a -> [a]
fromBush = foldBush tip node where
    tip :: [a]
    tip = []
    node :: [a] -> a -> [a] -> [a]
    node ls x rs = ls ++ (x : rs)
```

## Tree to List

```
fromTree :: Tree a -> [a]
fromTree = foldTree leaf fork where
    leaf :: a -> [a]
    leaf = (: [])
    fork :: [a] -> [a] -> [a]
    fork ls rs = ls ++ rs
```

## Size of Tree

- Without explicitly using recursion or folds
    - Define `sizeTree`

```
sizeTree :: Tree a -> Int
sizeTree = length . fromTree
```

# Maps

- Maps are data structures that store keys and their associated values
- Maps will be the first example of an abstract datatype
    - Where we do not have access to the internal structure
    - All we have are the operations

- For intuition, we can think of a Map as a function of type
    - `k -> Maybe v`
    - `k` is the key type
    - `v` is the value type

- In other words, we provide a Map with a key k and we maybe get a value back
    - Classic example is the phone book

- The type of a map is
    - `Map k v`
    - In practice, we import them from the `Data.Map`

## Empty Map

- The most basic map operation returns the empty map

- `empty :: Map k v`

## Looking Up Values

- We can extract values from a map using the lookup function

- `lookup :: Ord k => k -> Map k v -> Maybe v`

- We can understand the operations by their interactions

- `lookup k empty = Nothing` ∀ `k`

## Inserting Values

- We also have a way to insert values into the map

- `insert :: Ord k => k -> v -> Map k v -> Map k v`

- We expect that the following holds

- `lookup k (insert k v m) = Just v`

- This tells us that we insert a key into the map that already exists then, we
  overwrite the old value

# Tries

- A Trie structure is very efficient for mapping keys that can be decomposed
  into lists
- Here is a Trie structure for names

```
         0
     'A'/ \ 'J'
       0   0
   'n'/     \ 'o'
     0       2
 'n'/    'n'/ \ 'e'
   10     10   20
'e'/
  14
```

- This is a `Trie Char Int`
    - `Char` is the type of the edges
    - `Int` is the type of the nodes

- We can implement a Trie using a Map

```
data Trie k v = Trie (Maybe v) (Map k (Trie k v))
```

- We can think of `Trie k v` as being a `Map [k] v`

## Empty Trie

- A Trie can be empty

```
empty :: Trie k v
empty = Trie Nothing Map.empty
```

## Single Element

- We can have a single element `Trie`

```
single :: v -> Trie k v
single x = Trie (Just x) M.empty
```

## Name clashes

- To avoid name clashes, we import external names in a qualified way
- The following line would be at the top of the file

- `import qualified Data.Map as M`

## Lookup

```
lookup :: Ord => [k] -> Trie k v -> Maybe v
lookup [] (Trie mv kvs)     = mv
lookup (k:ks) (Trie mv kvs) =
    case M.lookup k kvs of
        Nothing -> Nothing
        Just ts -> lookup ks ts
```

## Insert

- To insert a value into a `Trie`, we take in a list of keys and generate
  `Trie`s as appropriate, one for each character in the keys

```
insert :: Ord k => [k] -> v -> Trie k v -> Trie k v
insert [] v (Trie mv kvs)     = Trie (Just v) kvs
insert (k:ks) v (Trie mv kvs) = Trie mv kvs' where
    kvs' :: Map k (Trie k v)
    kvs' = case M.lookup k kvs of
        Nothing -> M.insert k (insert ks v empty) kvs
        Just ts -> M.insert k (insert ks v ts) kvs
```

- This implementation replaces `mv`
- The `insert` function destroys data that is already in the `Trie`
- We need a similar version that updates values instead

```
update :: Ord k => [k] -> (v -> Maybe v) -> Trie k v -> Trie k v
update [] f (Trie Nothing kvs)  = Trie Nothing kvs
update [] f (Trie (Just x) kvs) = Trie (f x) kvs
update (k:ks) f (Trie mv kvs) = Trie mv kvs' where
    kvs' :: Map k (Trie k v)
    kvs' = case M.lookup k kvs of
        Nothing -> kvs
        Just ts -> M.update (Just . update ks f) k kvs
```

## Delete

```
delete :: Ord k => [k] -> Trie k v -> Trie k v
delete ks t = update ks (const Nothing) t
```

## List to Trie

- A useful function that we can define is to create a `Trie` from a list of keys
  and values
- So we define

```
makeTrie :: [String] -> Trie Char Int
makeTrie xs = foldr f k xs where
    k :: Trie Char Int
    k = empty
    f :: String -> Trie Char Int -> Trie Char Int
    f w t = adjust w incr t
```

- This is going to be using two functions `adjust` and `incr`

```
incr :: Maybe Int -> Maybe Int
incr Nothing = Just 1
incr (Just n) = Just (n + 1)
```

- The function `adjust` will apply `incr` to that when the node is empty (i.e.
  Nothing) then we have `Just 1` otherwise we get a value and increment it

# Monads

- Earlier we looked at functors
- A functor has an `fmap` operation which this type
    - `fmap :: (a -> b) -> f a -> f b`

- The type of `(reverse) bind` is
    - `(=<<) :: (a -> m b) -> m a -> m b`
    - Note the similarity in those signatures

- A monad is a class of types with the following operations defined

```
class Monad m where
    return :: a -> m a
    (>>=)  :: m a -> (a -> m b) -> m b
```

- The intuition is that `(>>=)` (pronounced "bind") is essentially a very
  pedantic `;`, from the imperative world

- `p >>= \x -> f x`
    - `p` - initial program
    - `x` - result of first program
    - `f` - takes the result and produces the next program

1. First execute `p`
2. We call the result of `p` the value `x`
3. Use `x` with `f` to make the next program
4. Execute `f x`

## Example

- `x = 5; x = x + 1`
    - `x = 5` - `p`
    - `;` - `>>=`
    - `x' = x + 1` - `\x -> f x`

- Roughly speaking `f x` = `x + 1`, in this example

## Monadic Laws

- A valid monad instance must satisfy 3 laws

1. Left return law
    - `return x >>= f` = `f x`
2. Right-return
    - `mx >>= return` = `mx`
3. Associative-bind
    - `(mx >>= f) >>= g` = `mx >>= (\x -> f x >>= g)`

- Since these are the monadic laws, we do not have much information about what a
  monad can do
- Monads are interesting not because of return and `>>=`, but because of the way
  other operations interact with these
- Every monad is a functor

## Identity Monad

- The simplest monad is the identity monad

- `newtype Id a = Id a`
    - Left `Id` is the type
    - Right `Id` is the constructor

- The functor instance for `Id` is this

```
instance Functor Id where
    -- fmap :: (a -> b) -> Id a -> Id b
    fmap f (Id x) = Id (f x)
```

- The monadic instance is as follows

```
instance Monad Id where
    -- return :: a -> m a
    return x = Id x
    -- (>>=) :: m a -> (a -> m b) -> m b
    (Id x) >>= f = f x
```
