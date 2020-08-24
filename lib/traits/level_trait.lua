level_trait = {}

level_trait.init = function(self)

  self.setup_level = function(self)
    self.level = 50
  end

  self.set_level = function(self, i)
      self.level = util.clamp(i, 0, 100)
      self.callback(self, 'set_level')
  end

end