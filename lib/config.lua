config = {}

config["settings"] = {
  ["version_major"] = 1,
  ["version_minor"] = 1,
  ["version_patch"] = 2,
  ["playback"] = 0,
  ["length"] = 16,
  ["root"] = 0,
  ["scale"] = 1,
  ["octaves"] = 11,
  ["delete_all_length"] = 3,
  ["save_path"] = _path.audio .. "arcologies/",
  ["crypt_path"] =  _path.audio .. "arcologies/crypt/",
  ["crypt_default_name"] = "DEFAULT",
  ["crypts_path"] =  _path.audio .. "crypts/"
}

config["page_titles"] = {
  "ARCOLOGIES",
  "DESIGNER",
  "ANALYSIS"
}
if config.settings.dev_mode then
  table.insert(config.page_titles, "DEV")
end

config["home_items"] = {
  "BPM",
  "LENGTH",
  "ROOT",
  "SCALE",
  "DOCS"
}

--[[

to add new structures, minimally:

 - config.structures
 - config.structure_attribute_map
 - keepper:collision()

structure names must be a single word

]]

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
  "SOLARIUM",
  "UXB",
  "CASINO",
  "TUNNEL",
  "AVIARY",
  "FOREST",
  "HYDROPONICS",
  "INSTITUTION",
  "MIRAGE",
  "BANK",
  "SPOMENIK",
  "AUTON"
}

config["attributes"] = {
  "AMORTIZE",
  "CAPACITY",
  "CHARGE",
  "CROW OUT",
  "CRUMBLE",
  "DEFLECT",
  "DEPRECIATE",
  "DOCS",
  "DRIFT",
  "DURATION",
  "INDEX",
  "INTEREST",
  "LEVEL",
  "METABOLISM",
  "NET INCOME",
  "NETWORK",
  "NOTES",
  "OFFSET",
  "OPERATOR",
  "PULSES",
  "RANGE MAX",
  "RANGE MIN",
  "STRUCTURE",
  "TAXES",
  "TERRITORY",
  "VELOCITY"
}

config["structure_attribute_map"] = {
  ["HIVE"] = {
    "METABOLISM",
    "OFFSET",
    "DOCS",
    "STRUCTURE"
  },
  ["SHRINE"] = {
    "NOTES",
    "VELOCITY",
    "DOCS",
    "STRUCTURE"
  },
  ["GATE"] = {
    "DOCS",
    "STRUCTURE"
  },
  ["RAVE"] = {
    "METABOLISM",
    "OFFSET",
    "DOCS",
    "STRUCTURE"
  },
  ["TOPIARY"] = {
    "INDEX",
    "NOTES",
    "VELOCITY",
    "DOCS",
    "STRUCTURE"
    },
  ["DOME"] = {
    "METABOLISM",
    "OFFSET",
    "PULSES",
    "DOCS",
    "STRUCTURE"
  },
  ["MAZE"] = {
    "METABOLISM",
    "OFFSET",
    "PROBABILITY",
    "DOCS",
    "STRUCTURE"
  },
  ["CRYPT"] = {
    "INDEX",
    "LEVEL",
    "DOCS",
    "STRUCTURE"
  },
  ["VALE"] = {
    "RANGE MIN",
    "RANGE MAX",
    "VELOCITY",
    "DOCS",
    "STRUCTURE"
  },
  ["SOLARIUM"] = {
    "CHARGE",
    "CAPACITY",
    "DOCS",
    "STRUCTURE"
  },
  ["UXB"] = {
    "NOTES",
    "VELOCITY",
    "DURATION",
    "DEVICE",
    "DOCS",
    "STRUCTURE"
  },
  ["CASINO"] = {
    "INDEX",
    "NOTES",
    "DURATION",
    "VELOCITY",
    "DEVICE",
    "DOCS",
    "STRUCTURE"
  },
  ["TUNNEL"] = {
    "NETWORK",
    "DOCS",
    "STRUCTURE"
  },
  ["AVIARY"] = {
    "NOTES",
    "CROW OUT",
    "DOCS",
    "STRUCTURE"
  },
  ["FOREST"] = {
    "INDEX",
    "NOTES",
    "CROW OUT",
    "DOCS",
    "STRUCTURE"
  },
  ["HYDROPONICS"] = {
    "METABOLISM",
    "OPERATOR",
    "TERRITORY",
    "DOCS",
    "STRUCTURE"
  },
  ["INSTITUTION"] = {
    "CRUMBLE",
    "DEFLECT",
    "DOCS",
    "STRUCTURE"
  },
  ["MIRAGE"] = {
    "METABOLISM",
    "DRIFT",
    "DOCS",
    "STRUCTURE"
  },
  ["BANK"] = {
    "NET INCOME",
    "INTEREST",
    "TAXES",
    "DEPRECIATE",
    "AMORTIZE",
    "DOCS",
    "STRUCTURE"
  },
  ["SPOMENIK"] = {
    "INDEX",
    "NOTES",
    "DOCS",
    "STRUCTURE"
  },
  ["AUTON"] = {
    "INDEX",
    "NOTES",
    "DOCS",
    "STRUCTURE"
  }
}

local note_message = {
  ["start"] = "NOTE...",
  ["abort"] = "ABORTED",
  ["done"] = "CHOSE"
}

config["popup_messages"] = {
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