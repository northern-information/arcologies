-- wip
-- todo: add requirements notes
nb_mixin = {}

nb_mixin.init = function(self)

  self.setup_nb = function(self)
    self.nb_key = "NB"
    self.nb = {}
  end

  self.get_nb = function(self)
    return self.nb
  end

  self.set_nb = function(self, i)
    self.nb = {}
    print("nb business logic stuff happens here")
    self.callback(self, "set_nb")
  end

end