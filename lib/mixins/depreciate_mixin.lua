depreciate_mixin = {}

depreciate_mixin.init = function(self)

  self.setup_depreciate = function(self)
    self.depreciate_key = "DEPRECIATE"
    self.depreciate = 31
    self:register_menu_getter(self.depreciate_key, self.depreciate_menu_getter)
    self:register_menu_setter(self.depreciate_key, self.depreciate_menu_setter)
  end

  self.get_depreciate = function(self)
    return self.depreciate
  end

  self.set_depreciate = function(self, i)
    self.depreciate = util.clamp(i, -50, 100)
    self.callback(self, "set_depreciate")
  end

  self.depreciate_menu_getter = function(self)
    return self:get_depreciate() .. "0kVE"
  end

  self.depreciate_menu_setter = function(self, i)
    self:set_depreciate(self.depreciate + i)
  end

end