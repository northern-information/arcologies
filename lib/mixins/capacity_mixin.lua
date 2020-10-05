capacity_mixin = {}

capacity_mixin.init = function(self)

  self.setup_capacity = function(self)
    self.capacity_key = "CAPACITY"
    self.capacity = 4
    self.capacity_min = 0
    self.capacity_max = 100
    self:register_save_key("capacity")
    self:register_menu_getter(self.capacity_key, self.capacity_menu_getter)
    self:register_menu_setter(self.capacity_key, self.capacity_menu_setter)
    self:register_arc_style({
      key = self.capacity_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.capacity_min,
      max = self.capacity_max,
      value_getter = self.get_capacity,
      value_setter = self.set_capacity
    })
  end

  self.get_capacity = function(self)
    return self.capacity
  end

  self.set_capacity = function(self, i)
    self.capacity = util.clamp(i, self.capacity_min, self.capacity_max)
    self.callback(self, "set_capacity")
  end

  self.capacity_menu_getter = function(self)
    return self:get_capacity()
  end

  self.capacity_menu_setter = function(self, i)
    self:set_capacity(self.capacity + i)
  end

end