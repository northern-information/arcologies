output_mixin = {}

output_mixin.init = function(self)

  self.setup_output = function(self)
    self.output_key = "OUTPUT"
    self.output = 1
    self:register_save_key("output")
    self.output_menu_values = { "SYNTH", "MIDI" }
    self:register_menu_getter(self.output_key, self.output_menu_getter)
    self:register_menu_setter(self.output_key, self.output_menu_setter)
  end

  self.get_output = function(self)
    return self.output
  end

  self.get_output_string = function(self)
    return self.output_menu_values[self:get_output()]
  end

  self.set_output = function(self, i)
    self.output = util.clamp(i, 1, #self.output_menu_values)
    self.callback(self, "set_output")
  end

  self.output_menu_getter = function(self)
    return self:get_output_string()
  end

  self.output_menu_setter = function(self, i)
    self:set_output(self.output + i)
  end

  self.check_output_items = function(self, items)
    if self.output_menu_values[self:get_output()] ~= "MIDI" then
      local remove = {"DURATION", "CHANNEL", "DEVICE"}
      for k, v in pairs(remove) do
        if self:has(v) then
          table.remove(items, fn.table_find(items, v))
        end
      end
    end
    return items
  end

end