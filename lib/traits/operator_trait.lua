operator_trait = {}

operator_trait.init = function(self)

  self.setup_operator = function(self)
    self.operator = 1
    self.operator_values = { "ADD", "SUBTRACT", "MULTIPLY", "DIVIDE", "MODULO", "SET" }
  end

  self.set_operator = function(self, i)
    self.operator = util.clamp(i, 1, 6)
    self.callback(self, "set_operator")
  end

  self.get_operator_value = function(self)
    return self.operator_values[self.operator]
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