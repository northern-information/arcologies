taxes_mixin = {}

taxes_mixin.init = function(self)

  self.setup_taxes = function(self)
    self.taxes_key = "TAXES"
    self.taxes = -7
    self:register_menu_getter(self.taxes_key, self.taxes_menu_getter)
    self:register_menu_setter(self.taxes_key, self.taxes_menu_setter)
  end

  self.get_taxes = function(self)
    return self.taxes
  end

  self.set_taxes = function(self, i)
    self.taxes = util.clamp(i, -100, 100)
    self.callback(self, "set_taxes")
  end

  self.taxes_menu_getter = function(self)
    return "<:" ..  self:get_taxes() .. ":GdQ"
  end

  self.taxes_menu_setter = function(self, i)
    self:set_taxes(self.taxes + i)
  end

end