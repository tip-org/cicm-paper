module Nat where

import Prelude ()
import Tip.DSL

data Nat = Zero | Succ Nat

(+) :: Nat -> Nat -> Nat
Zero + m = m
Succ n' + m = Succ (n' + m)

prop_comm n m = n + m =:= m + n
