interest_mixin = {}

interest_mixin.init = function(self)

  self.setup_interest = function(self)
    self.interest_key = "INTEREST"
    self.interest = 4
    self:register_menu_getter(self.interest_key, self.interest_menu_getter)
    self:register_menu_setter(self.interest_key, self.interest_menu_setter)
  end

  self.get_interest = function(self)
    return self.interest
  end

  self.set_interest = function(self, i)
    self.interest = util.clamp(i, 0, 100)
    self.callback(self, "set_interest")
  end

  self.interest_menu_getter = function(self)
    return "=" .. self:get_interest() .. "%(#7)"
  end

  self.interest_menu_setter = function(self, i)
    self:set_interest(self.interest + i)
  end

end