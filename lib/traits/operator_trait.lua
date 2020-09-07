operator_trait = {}

operator_trait.init = function(self)

  self.setup_operator = function(self)
    self.operator = 4
  end

  self.set_operator = function(self, i)
    self.operator = util.clamp(i, 0, 100)
    self.callback(self, 'set_operator')
  end

end