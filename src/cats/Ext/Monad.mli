open Sig
open TyCon

module Make : functor (M : MONAD) -> sig open M
  val ap : ('a -> 'b) T.el -> ('a T.el -> 'b T.el)
  val join : 'a T.el T.el -> 'a T.el
end
