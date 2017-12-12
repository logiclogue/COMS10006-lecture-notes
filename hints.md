# Lambda Caculus

- 3 components
- Variables
- Lambda abstractions
- Application

# Functional Programming

- PODs
- Functions
- Evaluation
- Lazy evaluation
- Normal order
- Eager evaluation
- Applicative order
- Church-rosser theorem
- Currying
- Uncurrying
- Inhabitants
- Extensionality
- Leibniz's law
- List comprehensions
- Name clashes syntax
- Case syntax

# Evaluating by hand

- `=`
- `⇔`
- `⇒`
- Induction

# Functions

- `head`
- `tail`
- `length`
- `isEmpty`
- `isSingle`
- `take`
- `drop`
- `(++)`
- `filter`
- `otherwise`
- `odd`
- `curry`
- `uncurry`
- `(.)`
- `($)`
- `map`
- `foldr`
- `sum`
- `product`
- `fmap`
- `elem`

# Typeclasses

- `class`
- `instance`

- `Num` class
- `Show` class
- `Monoid` class
- `Functor` class

# Data types

- `newtype`
- `data`

- `Bool`
- `Maybe`
- `Tree`
- `Bush`

# Functor

- 1 function
- 2 laws

# Monoids

- Associate
- Neutral element
- XOR symbol
- ∅
- 3 laws
- Free monoid
- Functions

# Trees

- `Tree`
- `Bush`

- `mapTree`
- `mapBush`

- `insert`
- `toBush`
- `toTree`
- `fromBush`
- `fromTree`
- `elemBush`
- `elemTree`
- `sizeBush`
- `heightBush`
- `foldBush`
- `foldTree`

- Leaf
- Fork
- Tip
- Node

# Maps

- Abstract data type

- `empty`
- `lookup`
- `insert`

# Tries

- Constructor

- `empty`
- `single`
- `lookup`
- `insert`
- `update`
- `delete`
- `makeTrie`

# Monads

- 2 functions
- 3 laws
- Reverse bind
- Identity monad
- Maybe monad
- Fail monad
- 1 monad fail function
- 1 monad fail law
- `MonadAlt`
- 1 monad alt function
- 2 monad alt laws
- `MonadNondet`

# Efficiency

- Complexity of `(xs ++ ys) ++ zs`
- Complexity of `reverse xs`
- Accumulator
- Cayley representation
- Difference lists
- Empty difference list
