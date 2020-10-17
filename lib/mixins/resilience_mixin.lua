resilience_mixin = {}

resilience_mixin.init = function(self)

  self.setup_resilience = function(self)
    self.resilience_key = "RESILIENCE"
    self.resilience = 50
    self.resilience_min = 0
    self.resilience_max = 100
    self:register_save_key("resilience")
    self:register_menu_getter(self.resilience_key, self.resilience_menu_getter)
    self:register_menu_setter(self.resilience_key, self.resilience_menu_setter)
    self:register_arc_style({
      key = self.resilience_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.resilience_min,
      max = self.resilience_max,
      value_getter = self.get_resilience,
      value_setter = self.set_resilience
    })
   self:register_modulation_target({
      key = self.resilience_key,
      inc = self.resilience_increment,
      dec = self.resilience_decrement
    })
  end

  self.resilience_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_resilience(self:get_resilience() + value)
  end

  self.resilience_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_resilience(self:get_resilience() - value)
  end

  self.get_resilience = function(self)
    return self.resilience
  end

  self.set_resilience = function(self, i)
    self.resilience = util.clamp(i, self.resilience_min, self.resilience_max)
    self.callback(self, "set_resilience")
  end

  self.resilience_menu_getter = function(self)
    return self:get_resilience() .. "%"
  end

  self.resilience_menu_setter = function(self, i)
    self:set_resilience(self.resilience + i)
  end

end