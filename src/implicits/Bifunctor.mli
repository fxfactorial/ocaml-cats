open Prelude
open Prelude.Sig
open Prelude.Ty

val bimap : (implicit M : BIFUNCTOR)
  -> ('a -> 'b)
  -> ('c -> 'd)
  -> (('a, 'c) M.T.el -> ('b, 'd) M.T.el)

implicit module Tuple : module type of Mod.Bifunctor.Tuple
implicit module Variant : module type of Mod.Bifunctor.Variant
