charge_mixin = {}

charge_mixin.init = function(self)

  self.setup_charge = function(self)
    self.charge_key = "CHARGE"
    self.charge = 0
    self:register_save_key("charge")
    self:register_menu_getter(self.charge_key, self.charge_menu_getter)
    self:register_menu_setter(self.charge_key, self.charge_menu_setter)
  end

  self.get_charge = function(self)
    return self.charge
  end

  self.set_charge = function(self, i)
    self.charge = util.clamp(i, 0, 100)
    self.callback(self, "set_charge")
  end

  self.charge_menu_getter = function(self)
    return self:get_charge()
  end

  self.charge_menu_setter = function(self, i)
    self:set_charge(self.charge + i)
  end

end