config = {}

config["settings"] = {
  ["playback"] = 0,
  ["length"] = 16,
  ["root"] = 0,
  ["scale"] = 1,
  ["octaves"] = 11
}

config["outputs"] = {
  ["midi"] = false,
  ["crow"] = false,
  ["jf"] = false
}

config["page_titles"] = {
  "ARCOLOGIES",
  "DESIGNER",
  "ANALYSIS",
  "DEV"
}

config["home_items"] = {
  "SEED",
  "BPM",
  "LENGTH",
  "ROOT",
  "SCALE",
  "DOCS"
}

config["analysis_items"] = {
  "SIGNALS",
  "HIVE",
  "SHRINE",
  "GATE",
  "RAVE",
  "TOPIARY",
  "DOME",
  "MAZE"
}

config["structures"] = {
  "HIVE",
  "SHRINE",
  "GATE",
  "RAVE",
  "TOPIARY",
  "DOME",
  "MAZE"
}

config["attributes"] = {
  "STRUCTURE",
  "OFFSET",
  "VELOCITY",
  "METABOLISM",
  "DOCS",
  "PULSES",
  "INDEX",
  "NOTE 1",
  "NOTE 2",
  "NOTE 3",
  "NOTE 4",
  "NOTE 5",
  "NOTE 6",
  "NOTE 7",
  "NOTE 8"
}

config["structure_attribute_map"] = {
  ["HIVE"] = {
    "OFFSET",
    "METABOLISM",
    "STRUCTURE",
    "DOCS"
  },
  ["SHRINE"] = {
    "NOTE 1",
    "VELOCITY",
    "STRUCTURE",
    "DOCS"
  },
  ["GATE"] = {
    "STRUCTURE",
    "DOCS"
  },
  ["RAVE"] = {
    "OFFSET",
    "METABOLISM",
    "STRUCTURE",
    "DOCS"
  },
  ["TOPIARY"] = {
    "INDEX",
    "NOTE 1",
    "NOTE 2",
    "NOTE 3",
    "NOTE 4",
    "NOTE 5",
    "NOTE 6",
    "NOTE 7",
    "NOTE 8",
    "VELOCITY",
    "STRUCTURE",
    "DOCS"
    },
  ["DOME"] = {
    "OFFSET",
    "METABOLISM",
    "PULSES",
    "STRUCTURE",
    "DOCS"
  },
  ["MAZE"] = {
    "INDEX",
    "OFFSET",
    "METABOLISM",
    "PROBABILITY",
    "STRUCTURE",
    "DOCS"
  }
}

local note_message = { 
  ["start"] = "NOTE...",
  ["abort"] = "ABORTED",
  ["done"] = "CHOSE"
}

config["popup_messages"] = {
  ["seed"] = {
    ["start"] = "SEEDING...",
    ["abort"] = "ABORTED SEED",
    ["done"] = "SEEDED"
  },
  ["delete_all"] = {
    ["start"] = "DELETING ALL IN...",
    ["abort"] = "ABORTED",
    ["done"] = "DELETED ALL CELLS"
  },
  ["structure"] = {
    ["start"] = "",
    ["abort"] = "",
    ["done"] = "CHOSE"
  },
  ["note1"] = note_message,
  ["note2"] = note_message,
  ["note3"] = note_message,
  ["note4"] = note_message,
  ["note5"] = note_message,
  ["note6"] = note_message,
  ["note7"] = note_message,
  ["note8"] = note_message
}

return config