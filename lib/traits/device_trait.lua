device_trait = {}

device_trait.init = function(self)

  self.setup_device = function(self)
    self.device = 1
  end

  self.set_device = function(self, i)
    self.device = util.clamp(i, 1, 4)
    self.callback(self, 'set_device')
  end

end