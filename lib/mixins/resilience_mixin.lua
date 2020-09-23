resilience_mixin = {}

resilience_mixin.init = function(self)

  self.setup_resilience = function(self)
    self.resilience_key = "RESILIENCE"
    self.resilience = 50
    self:register_save_key("resilience")
    self:register_menu_getter(self.resilience_key, self.resilience_menu_getter)
    self:register_menu_setter(self.resilience_key, self.resilience_menu_setter)
  end

  self.get_resilience = function(self)
    return self.resilience
  end

  self.set_resilience = function(self, i)
    self.resilience = util.clamp(i, 0, 100)
    self.callback(self, "set_resilience")
  end

  self.resilience_menu_getter = function(self)
    return self:get_resilience() .. "%"
  end

  self.resilience_menu_setter = function(self, i)
    self:set_resilience(self.resilience + i)
  end

end