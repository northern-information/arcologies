net_income_trait = {}

net_income_trait.init = function(self)

  self.setup_net_income = function(self)
    self.net_income = 5
  end

  self.set_net_income = function(self, i)
    self.net_income = util.clamp(i, 0, 100)
    self.callback(self, "set_net_income")
  end

end