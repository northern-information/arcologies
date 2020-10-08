deflect_mixin = {}

deflect_mixin.init = function(self)

  self.setup_deflect = function(self)
    self.deflect_key = "DEFLECT"
    self.deflect = 1
    self.deflect_min = 1
    self.deflect_max = 4
    self:register_save_key("deflect")
    self.deflect_menu_values = {"NORTH", "EAST", "SOUTH", "WEST"}
    self:register_menu_getter(self.deflect_key, self.deflect_menu_getter)
    self:register_menu_setter(self.deflect_key, self.deflect_menu_setter)
    self:register_arc_style({
      key = self.deflect_key,
      style_getter = function() return "glowing_compass" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 0,
      wrap = true,
      snap = true,
      min = self.deflect_min,
      max = self.deflect_max,
      value_getter = self.get_deflect,
      value_setter = self.set_deflect
    })
  end

  self.get_deflect = function(self)
    return self.deflect
  end

  self.set_deflect = function(self, i)
    self.deflect = util.clamp(i, self.deflect_min, self.deflect_max)
    self.callback(self, "set_deflect")
  end

  self.deflect_menu_getter = function(self)
    return self.deflect_menu_values[self:get_deflect()]
  end

  self.deflect_menu_setter = function(self, i)
    self:set_deflect(self.deflect + i)
  end

end