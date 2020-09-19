channel_mixin = {}

channel_mixin.init = function(self)

  self.setup_channel = function(self)
    self.channel_key = "CHANNEL"
    self.channel = 1
    self:register_menu_getter(self.channel_key, self.channel_menu_getter)
    self:register_menu_setter(self.channel_key, self.channel_menu_setter)
  end

  self.get_channel = function(self)
    return self.channel
  end

  self.set_channel = function(self, i)
    self.channel = util.clamp(i, 1, 16)
    self.callback(self, "set_channel")
  end

  self.channel_menu_getter = function(self)
    return self:get_channel()
  end

  self.channel_menu_setter = function(self, i)
    self:set_channel(self.channel + i)
  end

end