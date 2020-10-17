channel_mixin = {}

channel_mixin.init = function(self)

  self.setup_channel = function(self)
    self.channel_key = "CHANNEL"
    self.channel = 1
    self.channel_min = 1
    self.channel_max = 16
    self:register_save_key("channel")
    self:register_menu_getter(self.channel_key, self.channel_menu_getter)
    self:register_menu_setter(self.channel_key, self.channel_menu_setter)
    self:register_arc_style({
      key = self.channel_key,
      style_getter = function() return "sweet_sixteen" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 180,
      wrap = false,
      snap = true,
      min = self.channel_min,
      max = self.channel_max,
      value_getter = self.get_channel,
      value_setter = self.set_channel
    })
    self:register_modulation_target({
      key = self.channel_key,
      inc = self.channel_increment,
      dec = self.channel_decrement
    })
  end

  self.channel_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_channel(self:get_channel() + value)
  end

  self.channel_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_channel(self:get_channel() - value)
  end

  self.get_channel = function(self)
    return self.channel
  end

  self.set_channel = function(self, i)
    self.channel = util.clamp(i, self.channel_min, self.channel_max)
    self.callback(self, "set_channel")
  end

  self.channel_menu_getter = function(self)
    return self:get_channel()
  end

  self.channel_menu_setter = function(self, i)
    self:set_channel(self.channel + i)
  end

end