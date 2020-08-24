-- requires metabolism
-- requires probability
turing_trait = {}

turing_trait.init = function(self)

  self.setup_turing = function(self)
    self.turing = {}
  end

  self.set_turing = function(self)
    -- randomly seed, will typically only be during instantiation
    if #self.turing == 0 and self.metabolism > 0 then
      for i = 1, self.metabolism do
        self.turing[i] = fn.coin() == 1
      end
    end

    -- pad the register with falses when metabolism grows
    if #self.turing < self.metabolism then
      for i = #self.turing + 1, self.metabolism do
        self.turing[i] = false
      end

    -- cut the end off of the metabolism shrinks
    elseif #self.turing > self.metabolism then
      for k,v in pairs(self.turing) do
        if k > self.metabolism then
          table.remove(self.turing, k)
        end
      end
    end

    -- check against the probability
    if (math.random(0, 99) < self.probability) then
      -- flip a coin to get our new value
      table.insert(self.turing, 1, fn.coin() == 1)
      -- remove the old value
      table.remove(self.turing, #self.turing)
    end

    self.callback(self, 'set_turing')
  end

end