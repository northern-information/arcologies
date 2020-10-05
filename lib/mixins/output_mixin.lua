output_mixin = {}

output_mixin.init = function(self)

  self.setup_output = function(self)
    self.output_key = "OUTPUT"
    self.output = 1
    self.output_min = 1
    self:register_save_key("output")
    self.output_menu_values = { "SYNTH", "MIDI" }
    self.output_max = #self.output_menu_values
    self:register_menu_getter(self.output_key, self.output_menu_getter)
    self:register_menu_setter(self.output_key, self.output_menu_setter)
    self:register_arc_style({
      key = self.output_key,
      style_getter = function() return "glowing_divided" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.output_min,
      max = self.output_max,
      value_getter = self.get_output,
      value_setter = self.set_output
    })
  end

  self.get_output = function(self)
    return self.output
  end

  self.get_output_string = function(self)
    return self.output_menu_values[self:get_output()]
  end

  self.set_output = function(self, i)
    self.output = util.clamp(i, self.output_min, self.output_max)
    self.callback(self, "set_output")
  end

  self.output_menu_getter = function(self)
    return self:get_output_string()
  end

  self.output_menu_setter = function(self, i)
    self:set_output(self.output + i)
  end

  self.set_output_by_string = function(self, string)
    local output = fn.table_find(self.output_menu_values, string)
    if output then 
      self:set_output(output)
    end
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