open Sig
open TyCon

module Cofree (F : TRAVERSABLE) = struct
  module Def = Def.Traversable.Cofree(F)
  module Ext = struct
    include Ext.Foldable.Make(Def)
    include Ext.Traversable.Make(Def)
  end
  include Def
  include Ext
end

module List = struct
  module Def = Def.Traversable.List
  module Ext = struct
    include Ext.Foldable.Make(Def)
    include Ext.Traversable.Make(Def)
  end
  include Def
  include Ext
end
