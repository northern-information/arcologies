-- requires metabolism
pulses_trait = {}
pulses_trait.init = function(self)
    self.pulses = 0
    self.set_pulses = function(self, i)
        self.pulses = util.clamp(i, 0, self.metabolism)
        self.callback(self, 'set_pulses')
    end 
end