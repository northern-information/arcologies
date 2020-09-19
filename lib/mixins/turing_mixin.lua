-- requires metabolism
-- requires probability
turing_mixin = {}

turing_mixin.init = function(self)

  self.setup_turing = function(self)
    self.turing_key = "TURING"
    self.turing = {}
  end

  self.get_turing = function(self)
    return self.turing
  end

  self.set_turing = function(self, i)
    local meta = self.metabolism
    local p = self.probability
    local t = {}

    t = (meta == 0) and {} or self.turing

    -- if our table is empty, randomize it
    if #t == 0 then
      for i = 1, 16 do
        self.turing[i] = fn.coin() == 1
      end
    end

    -- pad the register with falses when metabolism grows
    if #t < meta then
      for i = #t + 1, meta do
        t[i] = false
      end
    end

    -- cut the end off of the metabolism shrinks
    if #t > meta then
      for k,v in pairs(t) do
        if k > meta then
          table.remove(t, k)
        end
      end
    end

    -- check against the probability
    if (math.random(0, 99) < p) then
      -- flip a coin to get our new value
      table.insert(t, #t, fn.coin() == 1)
      -- remove the old value
      table.remove(t, 1)
    end
  
    self.turing = t
    self.callback(self, "set_turing")
  end

end