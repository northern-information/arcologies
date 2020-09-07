crumble_trait = {}

crumble_trait.init = function(self)

  self.setup_crumble = function(self)
    self.crumble = 4
  end

  self.set_crumble = function(self, i)
    self.crumble = util.clamp(i, 0, 100)
    self.callback(self, 'set_crumble')
  end

end