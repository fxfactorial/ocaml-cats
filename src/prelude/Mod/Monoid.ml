open Sig
open Ty.Sig

module Unit = struct
  module Def = struct
    include Semigroup.Unit.Def
    let unit = ()
  end
  include Def
end

module String = struct
  module Def = struct
    include Semigroup.String.Def
    let unit = ""
  end
  include Def
end

module Additive = struct
  module Int = struct
    module Def = struct
      include Semigroup.Additive.Int.Def
      let unit = 0
    end
    include Def
  end

  module Float = struct
    module Def = struct
      include Semigroup.Additive.Float.Def
      let unit = 0.0
    end
    include Def
  end
end

module Multiplicative = struct
  module Int = struct
    module Def = struct
      include Semigroup.Multiplicative.Int.Def
      let unit = 1
    end
    include Def
  end

  module Float = struct
    module Def = struct
      include Semigroup.Multiplicative.Float.Def
      let unit = 1.0
    end
    include Def
  end
end

module List (T : Nullary.EL) = struct
  module Dep = Semigroup.List(T)
  module Def = struct
    include Dep.Def
    let unit = []
  end
  include Def
end