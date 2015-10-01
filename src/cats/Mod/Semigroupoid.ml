open Sig

module Fun = struct
  module Def : SEMIGROUPOID
    with module T = Profunctor.Fun.Def.T =
  struct
    include Profunctor.Fun.Def
    let compose = Amb.compose
  end
  include Def
  include Ext.Semigroupoid.Make(Def)
end