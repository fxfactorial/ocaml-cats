open Sig
open TyCon

module Make (M : BIND) = struct open M
  let (>>=) = bind
  let (>=>) g f x = bind (f x) g
end
