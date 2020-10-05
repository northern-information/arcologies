-- requires ports
bearing_mixin = {}

bearing_mixin.init = function(self)

  self.setup_bearing = function(self)
    self.bearing_key = "BEARING"
    self.bearing = 1
    self.bearing_min = 1
    self.bearing_max = 4
    self:register_save_key("bearing")
    self.bearing_menu_values = {"NORTH", "EAST", "SOUTH", "WEST"}
    self:register_menu_getter(self.bearing_key, self.bearing_menu_getter)
    self:register_menu_setter(self.bearing_key, self.bearing_menu_setter)
    self:register_arc_style({
      key = self.bearing_key,
      style_getter = function() return "glowing_compass" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 0,
      wrap = true,
      snap = true,
      min = self.bearing_min,
      max = self.bearing_max,
      value_getter = self.get_bearing,
      value_setter = self.set_bearing
    })
  end

  self.get_bearing = function(self)
    return self.bearing
  end

  self.get_bearing_cardinal = function(self)
    return self.cardinals[self.bearing]
  end

  self.set_bearing = function(self, i)
    self.bearing = util.clamp(i, self.bearing_min, self.bearing_max)
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