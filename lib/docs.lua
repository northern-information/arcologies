docs = {}

function docs.init()
  docs.active = false
end

function docs:set_active(bool)
  self.active = bool
end

function docs:is_active()
  return self.active
end

docs["sheets"] = {}

docs.sheets["HOME"] = {
  "github.com/",
  " tyleretters/",
  " arcologies-docs",
  "",
  "l.llllllll.co/",
  " arcologies"
}

docs.sheets["HIVE"] = {
  "Emit signals at",
  "regular intervals.",
  "",
  "Metabolism cont-",
  "rols rate of signal",
  "creation."
}

docs.sheets["SHRINE"] = {
  "Plays notes via",
  "onboard synth.",
  "",
  "Routes the flow",
  "of signals to",
  "open ports."
}

docs.sheets["GATE"] = {
  "Routes the flow",
  "of signals to",
  "open ports.",
  "Signal collisions",
  "on closed ports",
  "invert all ports."
}

docs.sheets["RAVE"] = {
  "Emits signals like",
  "a hive, but on",
  "spawn all ports",
  "are randomly",
  "toggled."
}

docs.sheets["TOPIARY"] = {
  "Plays melodies.",
  "",
  "Routes signals",
  "to open ports."
}

docs.sheets["DOME"] = {
  "Emits signals in",
  "Euclidian rhythms",
  "Metabolism=steps",
  "Pulses = beats.",
  "Loops to fill",
  "total length."
}

docs.sheets["MAZE"] = {
  "Emits signals like",
  "a hive but via",
  "an analog shift",
  "register algo.",
  "Loops to fill",
  "total length."
}

docs.sheets["CRYPT"] = {
  "One-shot mono",
  "sampler. Put six",
  "{1,2,3,4,5,6}.wavs",
  "in",
  "dust.audio.crypt",
  "(docs online)"
}

docs.sheets["VALE"] = {
  "Randomly plays",
  "a synth or MIDI",
  "note within a",
  "range.",
  "Routes signals",
  "to open ports."
}

docs.sheets["SOLARIUM"] = {
  "Stores signals",
  "as charge.",
  "Once capacity is",
  "met invert ports",
  "to burst next",
  "beat."
}
docs.sheets["UXB"] = {
  "Send notes to",
  "MIDI devices.",
  "",
  "Routes signals",
  "to open ports."
}

docs.sheets["CASINO"] = {
  "Is to uxbs what",
  "topiaries are",
  "to shrines."
}

docs.sheets["TUNNEL"] = {
  "Routes incoming",
  "singles to each",
  "other tunnel",
  "on the same",
  "network."
}

docs.sheets["AVIARY"] = {
  "Send voltates &",
  "triggers to crow.",
  "",
  "Routes signals",
  "to open ports."
}

docs.sheets["FOREST"] = {
  "Is to aviaries",
  "what topiaries",
  "are to shrines."
}

docs.sheets["HYDROPONICS"] = {
  "Modulate the",
  "metabolism of",
  "other cells at",
  "a distance.",
  "Routes signals",
  "to open ports."
}

docs.sheets["INSTITUTION"] = {
  "Crumbles and",
  "deflects signals."
}

docs.sheets["MIRAGE"] = {
  "Drifts.",
  "",
  "Routes the flow",
  "of signals to",
  "open ports."
}

docs.sheets["SPOMENIK"] = {
  "Plays Just",
  "Friends via",
  "crow i2c."
}

docs.sheets["AUTON"] = {
  "Is to spomeniks",
  "what topiaries",
  "are to shrines."
}

docs.sheets["KUDZU"] = {
  "Grows.",
  "Crumbles.",
  "Blocks signals."
}

docs.sheets["WINDFARM"] = {
  "Emits signals like",
  "a hive, but",
  "spins."
}

docs.sheets["FRACTURE"] = {
  "Plays a synth or",
  "MIDI note at a",
  "random velocity",
  "within a range.",
  "Routes signals",
  "to open ports."
}

docs.sheets["CLOAKROOM"] = {
  "Increment or",
  "decrement all",
  "targets of",
  "adjacent cells.",
  "S & W ports: +",
  "N & E ports: -"
}

docs.sheets["APIARY"] = {
  "Write docs",
  "here!",
  "CAW!"
}

return docs