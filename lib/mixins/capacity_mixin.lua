capacity_mixin = {}

capacity_mixin.init = function(self)

  self.setup_capacity = function(self)
    self.capacity_key = "CAPACITY"
    self.capacity = 4
    self:register_menu_getter(self.capacity_key, self.capacity_menu_getter)
    self:register_menu_setter(self.capacity_key, self.capacity_menu_setter)
  end

  self.get_capacity = function(self)
    return self.capacity
  end

  self.set_capacity = function(self, i)
    self.capacity = util.clamp(i, 0, 100)
    self.callback(self, "set_capacity")
  end

  self.capacity_menu_getter = function(self)
    return self:get_capacity()
  end

  self.capacity_menu_setter = function(self, i)
    self:set_capacity(self.capacity + i)
  end

end