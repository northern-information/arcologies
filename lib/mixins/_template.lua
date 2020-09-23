foobar_mixin = {}

foobar_mixin.init = function(self)

  self.setup_foobar = function(self)
    -- configure the key once and only once
    self.foobar_key = "FOOBAR"
    -- the value is the lower case string
    self.foobar = 100
    -- the "save_key" is the attribute name to be used in saveload.lua: it much match above exactly
    self:register_save_key("foobar")
    -- register the menu getter and setter
    self:register_menu_getter(self.foobar_key, self.foobar_menu_getter)
    self:register_menu_setter(self.foobar_key, self.foobar_menu_setter)
  end

  -- get the value
  self.get_foobar = function(self)
    return self.foobar
  end

  -- set the value and trigger a callback
  self.set_foobar = function(self, i)
    self.foobar = util.clamp(i, 0, 100)
    self.callback(self, "set_foobar")
  end

  -- what displays in the cell designer panel
  self.foobar_menu_getter = function(self)
    return "[" .. self:get_foobar() .. "]"
  end

  -- usually set via encs
  self.foobar_menu_setter = function(self, i)
    self:set_foobar(self.foobar + i)
  end

end