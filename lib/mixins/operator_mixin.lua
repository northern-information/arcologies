operator_mixin = {}

operator_mixin.init = function(self)

  self.setup_operator = function(self)
    self.operator_key = "OPERATOR"
    self.operator = 1
    self:register_save_key("operator")
    self.operator_menu_values = { "ADD", "SUBTRACT", "MULTIPLY", "DIVIDE", "MODULO", "SET" }
    self:register_menu_getter(self.operator_key, self.operator_menu_getter)
    self:register_menu_setter(self.operator_key, self.operator_menu_setter)
  end

  self.get_operator = function(self)
    return self.operator
  end

  self.set_operator = function(self, i)
    self.operator = util.clamp(i, 1, 6)
    self.callback(self, "set_operator")
  end

  self.operator_menu_getter = function(self)
    return self.operator_menu_values[self:get_operator()]
  end

  self.operator_menu_setter = function(self, i)
    self:set_operator(self.operator + i)
  end

  self.run_operation = function(self, operand1, operand2)
    if self.operator == 1 then
      return operand1 + operand2
    elseif self.operator == 2 then
      return operand1 - operand2
    elseif self.operator == 3 then
      return operand1 * operand2
    elseif self.operator == 4 and operand2 ~= 0 then
      return operand1 / operand2
    elseif self.operator == 5 and operand2 ~= 0 then
      return operand1 % operand2
    elseif self.operator == 6 then
      return operand2
    else
      return 0
    end
  end

end