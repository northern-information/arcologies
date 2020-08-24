metabolism_trait = {}

metabolism_trait.init = function(self)

  self.setup_metabolism = function(self)
    self.metabolism = 4
  end

  self.set_metabolism = function(self, i)
    self.metabolism = util.clamp(i, 0, 16)
    self.callback(self, 'set_metabolism')
  end

end