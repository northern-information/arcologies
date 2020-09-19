-- structure is integral to Cell already
-- this stub is for normalized menu behavior
structure_stub_mixin = {}

structure_stub_mixin.init = function(self)

  self.setup_structure_stub = function(self)
    self.structure_stub_key = "STRUCTURE"
    self:register_menu_getter(self.structure_stub_key, self.structure_stub_menu_getter)
    self:register_menu_setter(self.structure_stub_key, self.structure_stub_menu_setter)
  end

  self.get_structure_stub = function(self)
    -- empty
  end

  self.set_structure_stub = function(self, i)
    -- empty
  end

  self.structure_stub_menu_getter = function(self)
    return ""
  end

  self.structure_stub_menu_setter = function(self, i)
    popup:launch("structure", i, "enc", 3)
  end

end