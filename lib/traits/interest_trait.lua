interest_trait = {}

interest_trait.init = function(self)

  self.setup_interest = function(self)
    self.interest = 4
  end

  self.set_interest = function(self, i)
    self.interest = util.clamp(i, 0, 100)
    self.callback(self, "set_interest")
  end

end