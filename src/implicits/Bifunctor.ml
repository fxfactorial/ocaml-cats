open Cats
open Cats.Sig

let bimap (implicit M : BIFUNCTOR) = M.bimap

implicit module Tuple = Mod.Bifunctor.Tuple
implicit module Variant = Mod.Bifunctor.Variant
