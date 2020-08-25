config = {}

config["settings"] = {
  ["playback"] = 0,
  ["length"] = 16,
  ["root"] = 0,
  ["scale"] = 1,
  ["octaves"] = 11,
  ["save_path"] = _path.audio .. "arcologies/",
  ["crypt_path"] =  _path.audio .. "arcologies/crypt/",
  ["crypts_path"] =  _path.audio .. "crypts/"
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
  "MAZE",
  "CRYPT",
  "VALE",
  "SOLARIUM"
}

config["structures"] = {
  "HIVE",
  "SHRINE",
  "GATE",
  "RAVE",
  "TOPIARY",
  "DOME",
  "MAZE",
  "CRYPT",
  "VALE",
  "SOLARIUM"
}

config["attributes"] = {
  "STRUCTURE",
  "OFFSET",
  "VELOCITY",
  "METABOLISM",
  "DOCS",
  "PULSES",
  "INDEX",
  "NOTES",
  "RANGE MIN",
  "RANGE MAX",
  "CHARGE",
  "CAPACITY"
}

config["structure_attribute_map"] = {
  ["HIVE"] = {
    "OFFSET",
    "METABOLISM",
    "STRUCTURE",
    "DOCS"
  },
  ["SHRINE"] = {
    "NOTES",
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
    "NOTES",
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
    "OFFSET",
    "METABOLISM",
    "PROBABILITY",
    "STRUCTURE",
    "DOCS"
  },
  ["CRYPT"] = {
    "INDEX",
    "LEVEL",
    "STRUCTURE",
    "DOCS"
  },
  ["VALE"] = {
    "RANGE MIN",
    "RANGE MAX",
    "VELOCITY",
    "STRUCTURE",
    "DOCS"
  },
  ["SOLARIUM"] = {
    "CHARGE",
    "CAPACITY",
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