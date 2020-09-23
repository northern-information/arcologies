range_mixin = {}

range_mixin.init = function(self)

  self.setup_range = function(self)
    self.range_min_key = "RANGE MIN"
    self.range_min = 0
    self:register_save_key("range_min")
    self:register_menu_getter(self.range_min_key, self.range_min_menu_getter)
    self:register_menu_setter(self.range_min_key, self.range_min_menu_setter)
    self.range_max_key = "RANGE MAX"
    self.range_max = 100
    self:register_save_key("range_max")
    self:register_menu_getter(self.range_max_key, self.range_max_menu_getter)
    self:register_menu_setter(self.range_max_key, self.range_max_menu_setter)
  end

  self.set_range_min = function(self, i)
    self.range_min = util.clamp(i, 0, 100)
    self.range_max = util.clamp(self.range_max, self.range_min, 100)
    self.callback(self, "set_range_min")
  end

  self.set_range_max = function(self, i)
    self.range_max = util.clamp(i, 0, 100)
    self.range_min = util.clamp(self.range_min, 0, self.range_max)
    self.callback(self, "set_range_max")
  end

  self.get_range_min = function(self) return self.range_min end
  self.get_range_max = function(self) return self.range_max end

  self.range_min_menu_getter = function(self) return self:get_range_min() .. "%" end
  self.range_max_menu_getter = function(self) return self:get_range_max() .. "%"  end

  self.range_min_menu_setter = function(self, i) self:set_range_min(self.range_min + i) end
  self.range_max_menu_setter = function(self, i) self:set_range_max(self.range_max + i) end

end