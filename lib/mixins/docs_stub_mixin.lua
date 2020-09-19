docs_stub_mixin = {}

docs_stub_mixin.init = function(self)

  self.setup_docs_stub = function(self)
    self.docs_stub_key = "DOCS"
    self:register_menu_getter(self.docs_stub_key, self.docs_stub_menu_getter)
    self:register_menu_setter(self.docs_stub_key, self.docs_stub_menu_setter)
  end

  self.get_docs_stub = function(self)
    -- empty
  end

  self.set_docs_stub = function(self, i)
    -- empty
  end

  self.docs_stub_menu_getter = function(self)
    return ""
  end

  self.docs_stub_menu_setter = function(self, i)
    -- empty
  end

end