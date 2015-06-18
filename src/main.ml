let undefined ?(message = "Undefined") _ = failwith message

let const : 'a -> ('b -> 'a) =
  fun x _ -> x

external id : 'a -> 'a = "%identity"

let (%>) : ('a -> 'b) -> ('b -> 'c) -> ('a -> 'c) =
  fun g f x -> f (g x)

let (%) : ('b -> 'c) -> ('a -> 'b) -> ('a -> 'c) =
  fun g f x -> g (f x)

let flip : ('a -> 'b -> 'c) -> ('b -> 'a -> 'c) =
  fun f x y -> f y x

let curry : ('a * 'b -> 'c) -> ('a -> ('b -> 'c)) =
  fun f x y -> f (x, y)

let uncurry : ('a -> ('b -> 'c)) -> ('a * 'b -> 'c) =
  fun f (x, y) -> f x y

let tap f x : ('a -> unit) -> ('a -> 'a)
  = f x; x

external (@@) : ('a -> 'b) -> ('a -> 'b) = "%apply"

external (|>) : 'a -> (('a -> 'r) -> 'r) = "%revapply"

module Sig = struct
  module type SEMIGROUP = sig
    type t
    val op : t -> t -> t
  end

  module type MONOID = sig
    include SEMIGROUP
    val unit : t
  end

  module type SEMIRING = sig
    type t
    val zero : t
    val add : t -> t -> t
    val one : t
    val mul : t -> t -> t
  end

  module type PROFUNCTOR = sig
    type (-'a, +'b) p
    val dimap : ('a -> 'b) -> ('c -> 'd) -> (('b, 'c) p -> ('a, 'd) p)
  end

  module type FUNCTOR =  sig
    type +'a t
    val map : ('a -> 'b) -> ('a t -> 'b t)
  end

  module type OPFUNCTOR = sig
    type -'a t
    val map : ('a -> 'b) -> ('b t -> 'a t)
  end

  module type SEMICATEGORY = sig
    include PROFUNCTOR
    val cmp : ('b, 'c) p -> ('a, 'b) p -> ('a, 'c) p
  end

  module type CATEGORY = sig
    include PROFUNCTOR
    val idn : ('a, 'a) p
  end

  module type APPLY = sig
    include FUNCTOR
    val apply : ('a -> 'b) t -> ('a t -> 'b t)
  end

  module type APPLICATIVE = sig
    include APPLY
    val pure : 'a -> 'a t
  end

  module type BIND = sig
    include APPLY
    val bind : 'a t -> ('a -> 'b t) -> 'b t
  end

  module type MONAD = sig
    include APPLICATIVE
    include (BIND with type 'a t := 'a t)
  end

  module type EXTEND = sig
    include FUNCTOR
    val extend : ('a t -> 'b) -> ('a t -> 'b t)
  end

  module type COMONAD = sig
    include EXTEND
    val extract : 'a t -> 'a
  end

  module type FOLDABLE = sig
    type 'a t
    val foldr : ('a -> 'b -> 'b) -> ('b -> 'a t -> 'b)
    val foldl : ('b -> 'a -> 'b) -> ('b -> 'a t -> 'b)
    val foldMap : (module MONOID with type t = 'm) -> ('a -> 'm) -> ('a t -> 'm)
  end
end

module Ext = struct
  module Profunctor = functor (T : Sig.PROFUNCTOR) -> struct
    let lmap : ('a -> 'b) -> (('b, 'c) T.p -> ('a, 'c) T.p)
      = fun f -> T.dimap f id
    let rmap : ('c -> 'd) -> (('b, 'c) T.p -> ('b, 'd) T.p)
      = fun f -> T.dimap id f
  end
end

module Semigroup = struct
  module Unit
    : (Sig.SEMIGROUP with type t = unit) =
  struct
    type t = unit
    let op _ _ = ()
  end

  module String
    : (Sig.SEMIGROUP with type t = string) =
  struct
    type t = string
    let op x y = String.concat "" [x; y]
  end

  module Additive = struct
    module Int
      : (Sig.SEMIGROUP with type t = int) =
    struct
      type t = int
      let op x y = x + y
    end
  end

  module Multiplicative = struct
    module Int
      : (Sig.SEMIGROUP with type t = int) =
    struct
      type t = int
      let op x y = x * y
    end
  end
end

module Monoid = struct
  module Additive = struct
    module Int
      : (Sig.MONOID with type t = int) =
    struct
      include Semigroup.Additive.Int
      let unit = 0
    end
  end

  module Multiplicative = struct
    module Int
      : (Sig.MONOID with type t = int) =
    struct
      include Semigroup.Multiplicative.Int
      let unit = 1
    end
  end
end

module Semiring = struct
  module Int
    : (Sig.SEMIRING with type t = int) =
  struct
    module Add = Monoid.Additive.Int
    module Mul = Monoid.Multiplicative.Int
    type t = int
    let zero = Add.unit
    let add x y = Add.op x y
    let one = Mul.unit
    let mul x y = Mul.op x y
  end
end

module Profunctor = struct
  module Fn = struct
    module Core
      : (Sig.PROFUNCTOR with type (-'a, +'b) p = 'a -> 'b) =
    struct
      type (-'a, +'b) p = 'a -> 'b
      let dimap f g h = g % h % f
    end
    include Core
    include Ext.Profunctor(Core)
  end
end
