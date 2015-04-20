module List where

import Prelude ()
import Tip.DSL

(++) :: [a] -> [a] -> [a]
[]     ++ ys = ys
(x:xs) ++ ys = x:(xs ++ ys)

prop_rid xs = xs ++ [] =:= xs

map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x:map f xs

prop_map f g xs = map (\ x -> f (g x)) xs =:= map f (map g xs)

