charge_mixin = {}

charge_mixin.init = function(self)

  self.setup_charge = function(self)
    self.charge_key = "CHARGE"
    self.charge = 0
    self.charge_min = 0
    self.charge_max = 100
    self:register_save_key("charge")
    self:register_menu_getter(self.charge_key, self.charge_menu_getter)
    self:register_menu_setter(self.charge_key, self.charge_menu_setter)
    self:register_arc_style({
      key = self.charge_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.charge_min,
      max = self.charge_max,
      value_getter = self.get_charge,
      value_setter = self.set_charge
    })
    self:register_modulation_target({
      key = self.charge_key,
      inc = self.charge_increment,
      dec = self.charge_decrement
    })
  end

  self.charge_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_charge(self:get_charge() + value)
  end

  self.charge_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_charge(self:get_charge() - value)
  end

  self.get_charge = function(self)
    return self.charge
  end

  self.set_charge = function(self, i)
    self.charge = util.clamp(i, self.charge_min, self.charge_max)
    self.callback(self, "set_charge")
  end

  self.charge_menu_getter = function(self)
    return self:get_charge()
  end

  self.charge_menu_setter = function(self, i)
    self:set_charge(self.charge + i)
  end

end