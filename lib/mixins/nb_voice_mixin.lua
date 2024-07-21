-- requires nb_select_mixin
-- chooses which NB voice to send the note to, (none, nb_out, emplaitress 1, ...)
nb_voice_mixin = {}

nb_voice_mixin.init = function(self)

  self.setup_nb_voice = function(self)
    -- nb_voice
    self.nb_voice_key = "NB VOICE"
    self.nb_voice = params:get("nb_1")
    self:register_save_key("nb_voice")
    
    -- the nb "note_players" variable ends up with connected midi devices, doesn't accurately list options in nb_1
    self.nb_voice_count = nb_player_count -- global from parameters.lua
    self:register_menu_getter(self.nb_voice_key, self.nb_voice_menu_getter)
    self:register_menu_setter(self.nb_voice_key, self.nb_voice_menu_setter)
    self:register_arc_style({
      key = self.nb_voice_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = 1,
      max = self.nb_voice_count, 
      value_getter = self.get_nb_voice,
      value_setter = self.set_nb_voice
    })

    self:register_modulation_target({
      key = self.nb_voice_key,
      inc = self.nb_voice_increment,
      dec = self.nb_voice_decrement
    })
  end

  self.nb_voice_increment = function(self, i)
    self.nb_voice = util.wrap(self:get_nb_voice() + 1, 1, self.nb_voice_count)
    self:set_nb_voice(self.nb_voice) -- sets the voice selector param
  end

  self.nb_voice_decrement = function(self, i)
    self.nb_voice = util.wrap(self:get_nb_voice() - 1, 1, self.nb_voice_count)
    self:set_nb_voice(self.nb_voice) -- sets the voice selector param
  end

  self.get_nb_voice = function(self)
    -- requires nb_select_mixin
    -- example: looks up "nb_1" and returns the index integer of nb voice
    return params:get(self.nb_select_menu_values[self.nb_select])
  end

  self.set_nb_voice = function(self, i)
    self.nb_voice = util.clamp(i, 1, self.nb_voice_count)
    params:set(self.nb_select_menu_values[self.nb_select], self.nb_voice)
    self.callback(self, "set_nb_voice")
  end

  self.nb_voice_menu_getter = function(self)
    return params:string(self.nb_select_menu_values[self.nb_select])
  end

  self.nb_voice_menu_setter = function(self, i)
    self:set_nb_voice(self:get_nb_voice() + i)
  end

end