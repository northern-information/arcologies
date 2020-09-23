-- requires ports
bearing_mixin = {}

bearing_mixin.init = function(self)

  self.setup_bearing = function(self)
    self.bearing_key = "BEARING"
    self.bearing = 1
    self:register_save_key("bearing")
    self.bearing_menu_values = {"NORTH", "EAST", "SOUTH", "WEST"}
    self:register_menu_getter(self.bearing_key, self.bearing_menu_getter)
    self:register_menu_setter(self.bearing_key, self.bearing_menu_setter)
  end

  self.get_bearing = function(self)
    return self.bearing
  end

  self.get_bearing_cardinal = function(self)
    return self.cardinals[self.bearing]
  end

  self.set_bearing = function(self, i)
    self.bearing = util.clamp(i, 1, 4)
    self.callback(self, "set_bearing")
  end

  self.bearing_menu_getter = function(self)
    return self.bearing_menu_values[self:get_bearing()]
  end

  self.bearing_menu_setter = function(self, i)
    self:cycle_bearing(i)
  end

  self.cycle_bearing = function(self, i)
    self:set_bearing(fn.cycle(self.bearing + i, 1, 4))
  end

end