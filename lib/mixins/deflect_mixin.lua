deflect_mixin = {}

deflect_mixin.init = function(self)

  self.setup_deflect = function(self)
    self.deflect_key = "DEFLECT"
    self.deflect = 1
    self.deflect_menu_values = {"NORTH", "EAST", "SOUTH", "WEST"}
    self:register_menu_getter(self.deflect_key, self.deflect_menu_getter)
    self:register_menu_setter(self.deflect_key, self.deflect_menu_setter)
  end

  self.get_deflect = function(self)
    return self.deflect
  end

  self.set_deflect = function(self, i)
    self.deflect = util.clamp(i, 1, 4)
    self.callback(self, "set_deflect")
  end

  self.deflect_menu_getter = function(self)
    return self.deflect_menu_values[self:get_deflect()]
  end

  self.deflect_menu_setter = function(self, i)
    self:set_deflect(self.deflect + i)
  end

end