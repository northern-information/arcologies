net_income_mixin = {}

net_income_mixin.init = function(self)

  self.setup_net_income = function(self)
    self.net_income_key = "NET INCOME"
    self.net_income = 5
    self:register_menu_getter(self.net_income_key, self.net_income_menu_getter)
    self:register_menu_setter(self.net_income_key, self.net_income_menu_setter)
  end

  self.get_net_income = function(self)
    return self.net_income
  end

  self.set_net_income = function(self, i)
    self.net_income = util.clamp(i, 0, 100)
    self.callback(self, "set_net_income")
  end

  self.net_income_menu_getter = function(self)
    return ">" .. self:get_net_income() .. ".0gDq"
  end

  self.net_income_menu_setter = function(self, i)
    self:set_net_income(self.net_income + i)
  end

end