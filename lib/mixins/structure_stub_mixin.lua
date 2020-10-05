-- structure is integral to Cell already
-- this stub is for normalized menu behavior
structure_stub_mixin = {}

structure_stub_mixin.init = function(self)

  self.setup_structure_stub = function(self)
    self.structure_stub_key = "STRUCTURE"
    self:register_menu_getter(self.structure_stub_key, self.structure_stub_menu_getter)
    self:register_menu_setter(self.structure_stub_key, self.structure_stub_menu_setter)
    -- self:register_arc_style({
    --   key = self.structure_stub_key,
    --   style_getter = function() return "glowing_divided" end,
    --   style_max_getter = function() return 360 end,
    --   sensitivity = .05,
    --   offset = 180,
    --   wrap = false,
    --   snap = true,
    --   min = 1,
    --   max = #structures:all_enabled(),
    --   value_getter = self.get_structure_stub,
    --   value_setter = self.set_structure_stub
    -- })
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