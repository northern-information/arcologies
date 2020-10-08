level_mixin = {}

level_mixin.init = function(self)

  self.setup_level = function(self)
    self.level_key = "LEVEL"
    self.level = 50
    self.level_min = 0
    self.level_max = 100
    self:register_save_key("level")
    self:register_menu_getter(self.level_key, self.level_menu_getter)
    self:register_menu_setter(self.level_key, self.level_menu_setter)
    self:register_arc_style({
      key = self.level_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.level_min,
      max = self.level_max,
      value_getter = self.get_level,
      value_setter = self.set_level
    })
  end

  self.get_level = function(self)
    return self.level
  end

  self.set_level = function(self, i)
    self.level = util.clamp(i, self.level_min, self.level_max)
    self.callback(self, "set_level")
  end

  self.level_menu_getter = function(self)
    return self:get_level() .. "%"
  end

  self.level_menu_setter = function(self, i)
    self:set_level(self.level + i)
  end

end