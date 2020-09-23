level_mixin = {}

level_mixin.init = function(self)

  self.setup_level = function(self)
    self.level_key = "LEVEL"
    self.level = 50
    self:register_save_key("level")
    self:register_menu_getter(self.level_key, self.level_menu_getter)
    self:register_menu_setter(self.level_key, self.level_menu_setter)
  end

  self.get_level = function(self)
    return self.level
  end

  self.set_level = function(self, i)
    self.level = util.clamp(i, 0, 100)
    self.callback(self, "set_level")
  end

  self.level_menu_getter = function(self)
    return self:get_level() .. "%"
  end

  self.level_menu_setter = function(self, i)
    self:set_level(self.level + i)
  end

end