-- wip
-- todo: add requirements notes
-- chooses which NB voice to send the note to, (none, nb_out, emplaitress 1, ...)
-- WARNING: This currently depends on nb_select_mixin, and needs to be called AFTER nb_select_mixin
nb_voice_mixin = {}

nb_voice_mixin.init = function(self)

  self.setup_nb_voice = function(self)
    -- nb_voice
    self.nb_voice_key = "NB VOICE"
    -- the value of this should be whatever nb_select_mixin value is
    -- it should look up the selected voice-selector then fill this value
    -- but we'll init to nb_1 since it won't initialize to anything differently ever I don't think
    -- hardcoded to "nb_1" is probably bad
    
    -- values throughout this class should always be just pulling from other places
    self.nb_voice = params:get("nb_1") -- we might not need this... we should just look up the param
    self:register_save_key("nb_voice")
    
    -- get list of all the keys in note_players, plus none
    -- note_players holds all the nb voices available in key value pairs
    -- (you could set the voice selector then get the hidden string for the voice)
    -- (but recreating a list of strings keeps this consistent with other mixins)
    self.nb_voice_menu_values = {}
    for k, v in pairs(note_players) do table.insert(self.nb_voice_menu_values, k) end
    table.sort(self.nb_voice_menu_values)
    table.insert(self.nb_voice_menu_values, 1, "none")
    self.nb_voice_count = #self.nb_voice_menu_values 


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
    -- TODO set the nb selector value?
    -- params:get(nb_select_menu_values[nb_select_mixin.get_nb_select()]) should return 2 for example
    -- add 1 and util.wrap the value between 1 and self.nb_voice_count
  end

  self.nb_voice_decrement = function(self, i)
    self.nb_voice = util.wrap(self:get_nb_voice() - 1, 1, self.nb_voice_count)
    -- TODO lookup which selector, then set that value
    -- params:get(nb_select_menu_values[nb_select_mixin.get_nb_select()]) should return 2 for example
    -- subtract 1 and util.wrap the value between 1 and self.nb_voice_count
  end

  self.get_nb_voice = function(self)
    -- TODO lookup value of nb_select_mixin
    -- nb_select_mixin.get_nb_select() should be 1, 2, 3, 4
    -- nb_select_menu_values[nb_select_mixin.get_nb_select()] should be "nb_1" for example
    -- params:get(nb_select_menu_values[nb_select_mixin.get_nb_select()] .. "_hidden_string") should return "emplait 1" if it's 2
    -- params:get(nb_select_menu_values[nb_select_mixin.get_nb_select()]) should return 2 for example
    -- this should return 2

    -- should look up selector and return voice-index number
    return params:get(nb_select_mixin.nb_select_menu_values[nb_select_mixin:get_nb_select()])
    -- return self.nb_voice
  end

  self.set_nb_voice = function(self, i)
    -- self.nb_voice = util.clamp(i, 1, self.nb_voice_count)
    local val = util.clamp(i, 1, self.nb_voice_count)
    -- get voice-selector, lookup the voice-selector param, set value
    params:set(nb_select_mixin.nb_select_menu_values[nb_select_mixin:get_nb_select()], val)
    self.callback(self, "set_nb_voice")
  end

  self.nb_voice_menu_getter = function(self)
    return self.nb_voice_menu_values[self:get_nb_voice()]
  end

  self.nb_voice_menu_setter = function(self, i)
    self:set_nb_voice(self.nb_voice + i)
  end

end