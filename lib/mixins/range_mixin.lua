range_mixin = {}

range_mixin.init = function(self)

  self.setup_range = function(self)
    self.range_min_key = "RANGE MIN"
    self.range_min = 0
    self.range_min_min = 0
    self.range_min_max = 100
    self:register_save_key("range_min")
    self:register_menu_getter(self.range_min_key, self.range_min_menu_getter)
    self:register_menu_setter(self.range_min_key, self.range_min_menu_setter)
    self:register_arc_style({
      key = self.range_min_key,
      style_getter = function() return "glowing_range" end,
      style_max_getter = function() return 360 end,
      sensitivity = .5,
      offset = 180,
      wrap = false,
      snap = false,
      min = self.range_min_min,
      max = self.range_min_max,
      value_getter = self.get_range_min,
      value_setter = self.set_range_min
    })
    self.range_max_key = "RANGE MAX"
    self.range_max = 100
    self.range_max_min = 0
    self.range_max_max = 100
    self:register_save_key("range_max")
    self:register_menu_getter(self.range_max_key, self.range_max_menu_getter)
    self:register_menu_setter(self.range_max_key, self.range_max_menu_setter)
    self:register_arc_style({
      key = self.range_max_key,
      style_getter = function() return "glowing_range" end,
      style_max_getter = function() return 360 end,
      sensitivity = .5,
      offset = 180,
      wrap = false,
      snap = false,
      min = self.range_max_min,
      max = self.range_max_max,
      value_getter = self.get_range_max,
      value_setter = self.set_range_max
    })
  end

  self.set_range_min = function(self, i)
    local min = util.clamp(i, self.range_min_min, self.range_min_max)
    self.range_min = min
    self.range_max_min = min
    self.range_max = util.clamp(self.range_max, self.range_min, 100)
    self.callback(self, "set_range_min")
  end

  self.set_range_max = function(self, i)
    local max = util.clamp(i, self.range_max_min, self.range_max_max)
    self.range_max = max
    self.range_min_max = max
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