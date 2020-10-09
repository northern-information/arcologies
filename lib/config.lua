config = {}

config["settings"] = {
  ["version_major"] = 1,
  ["version_minor"] = 2,
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
  ["crypts_path"] =  _path.audio .. "crypts/",
  ["maps_path"] =  _path.data .. "arcologies/maps/"
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
  "TRANSPOSE",
  "DOCS"
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
  ["note"] = {
    ["start"] = "NOTE...",
    ["abort"] = "ABORTED",
    ["done"] = "CHOSE"
  }
}

config["arc_bindings"] = {
  { id = "norns_e1", label = "NORNS E1" },
  { id = "norns_e2", label = "NORNS E2" },
  { id = "norns_e3", label = "NORNS E3" },
  { id = "browse_cells", label = "BROWSE CELLS" },
  { id = "crypt_directory", label = "CRYPT DIRECTORY" },
  { id = "danger_zone_clock_sync", label = "clock.sync(x)" },
  { id = "transpose", label = "TRANSPOSE" },
  { id = "bpm", label = "BPM" },
}

return config