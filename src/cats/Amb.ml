let undefined ?(message = "Undefined") _ = failwith message
external (@@) : ('a -> 'b) -> ('a -> 'b) = "%apply"
external (|>) : 'a -> (('a -> 'r) -> 'r) = "%revapply"

external id : 'a -> 'a = "%identity"
let compose g f x = g (f x)
let cons x xs = x :: xs
let const x _ = x
let flip f x y = f y x
let bang x = const () x
let diagonal x = (x, x)
let curry f x y = f (x, y)
let uncurry f (x, y) = f x y
let tap f x = f x; x

module Initial = struct
  type t
  let abort _ = failwith "Initial.abort"
end

module Coproduct = struct
  type ('a, 'b) t =
    | InL of 'a
    | InR of 'b
  let inl a = InL a
  let inr b = InR b
  let from f g x = match x with
    | InL a -> f a
    | InR b -> g b
end

module Product = struct
  type ('a, 'b) t = 'a * 'b
  let fst (x, y) = x
  let snd (x, y) = y
  let into f g p = (f p, g p)
  let pair x y = into (const x) (const y) ()
end
