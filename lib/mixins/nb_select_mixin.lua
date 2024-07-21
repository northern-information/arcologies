-- requires nb_voice_mixin
-- select nb selector 1, 2, 3, or 4
nb_select_mixin = {}

nb_select_mixin.init = function(self)

  self.setup_nb_select = function(self)
    -- nb_select
    self.nb_select_key = "NB SELECT"
    self.nb_select = 1
    self:register_save_key("nb_select")
    self.nb_select_menu_values = {"nb_1", "nb_2", "nb_3", "nb_4"}
    self.nb_select_count = 4 -- arbitrarily chosen maximum (8 sounds good tho)
    self:register_menu_getter(self.nb_select_key, self.nb_select_menu_getter)
    self:register_menu_setter(self.nb_select_key, self.nb_select_menu_setter)
    self:register_arc_style({
      key = self.nb_select_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = 1,
      max = self.nb_select_count,
      value_getter = self.get_nb_select,
      value_setter = self.set_nb_select
    })

    self:register_modulation_target({
      key = self.nb_select_key,
      inc = self.nb_select_increment,
      dec = self.nb_select_decrement
    })
  end

  self.nb_select_increment = function(self, i)
    self:set_nb_select(self.nb_select + 1)
  end

  self.nb_select_decrement = function(self, i)
    self:set_nb_select(self.nb_select - 1)
  end

  self.get_nb_select = function(self)
    return self.nb_select
  end

  self.set_nb_select = function(self, i)
    self.nb_select = util.clamp(i, 1, self.nb_select_count)
    self.callback(self, "set_nb_select")
  end

  self.nb_select_menu_getter = function(self)
    return self.nb_select_menu_values[self.nb_select]
  end

  self.nb_select_menu_setter = function(self, i)
    self:set_nb_select(self.nb_select + i)
  end

end