-- structure is integral to Cell already
-- this stub is for normalized menu behavior
structure_mixin = {}

structure_mixin.init = function(self)

  self.setup_structure = function(self)
    self.structure_name = structures:first() -- typically HIVE
    self.structure_key = "STRUCTURE"
    self.structure_min = 1
    self.structure_max = #structures:all_enabled()
    self:register_menu_getter(self.structure_key, self.structure_menu_getter)
    self:register_menu_setter(self.structure_key, self.structure_menu_setter)
    self:register_arc_style({
      key = self.structure_key,
      style_getter = function() return "glowing_structure" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.structure_min,
      max = self.structure_max,
      value_getter = self.get_structure,
      value_setter = self.set_structure
    })
  end

  self.get_structure = function(self)
    return structures:get_index(self.structure_name)
  end

  self.set_structure = function(self, i)
    self:change(structures:all_enabled()[i].name)
  end

  self.structure_menu_getter = function(self)
    return ""
  end

  self.structure_menu_setter = function(self, i)
    popup:launch("structure", i, "enc", 3)
  end

  self.is = function(self, name)
    return self.structure_name == name
  end

  self.has = function(self, name)
    return fn.table_has(self:get_attributes(), name)
  end

  self.get_attributes = function(self)
    return structures:get_structure_attributes(self.structure_name)
  end

  self.change = function(self, name)
    local match = false
    for k, v in pairs(structures:all_enabled()) do
      if v.name == name then
        self:set_structure_by_name(name)
        match = true
      end
    end
    if not match then
      self:set_structure_by_name(structures:first())
    end
  end

  self.set_structure_by_name = function(self, name)
    self.structure_name = name
    self:change_checks()
  end

end