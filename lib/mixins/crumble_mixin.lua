crumble_mixin = {}

crumble_mixin.init = function(self)

  self.setup_crumble = function(self)
    self.crumble_key = "CRUMBLE"
    self.crumble = 4
    self:register_save_key("crumble")
    self:register_menu_getter(self.crumble_key, self.crumble_menu_getter)
    self:register_menu_setter(self.crumble_key, self.crumble_menu_setter)
  end

  self.get_crumble = function(self)
    return self.crumble
  end

  self.set_crumble = function(self, i)
    self.crumble = util.clamp(i, 0, 100)
    self.callback(self, "set_crumble")
  end

  self.crumble_menu_getter = function(self)
    return self:get_crumble()
  end

  self.crumble_menu_setter = function(self, i)
    self:set_crumble(self.crumble + i)
  end

end