channel_trait = {}

channel_trait.init = function(self)

  self.setup_channel = function(self)
    self.channel = 1
  end

  self.set_channel = function(self, i)
    self.channel = util.clamp(i, 1, 16)
    self.callback(self, "set_channel")
  end

end