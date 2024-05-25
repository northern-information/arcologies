structures = {}

--[[

to add new structures and attributes, minimally:

 - structures:register()   this file
 - keeper:collision()      for business logic
 - new glyphs              automatically picked up via the structure string

structure names _must_ be a single word due to string matching for glyphs

]]

function structures.init()
  structures.order = 1
  structures.database = {}
  -- structures:register("STUBBY",       { "TERRITORY" })
  structures:register("HIVE",         { "METABOLISM", "OFFSET" })
  structures:register("SHRINE",       { "NOTES", "VELOCITY" })
  structures:register("GATE",         {})
  structures:register("RAVE",         { "METABOLISM", "OFFSET" })
  structures:register("TOPIARY",      { "INDEX", "NOTE COUNT", "NOTES", "TOPOGRAPHY", "VELOCITY" })
  structures:register("DOME",         { "METABOLISM", "OFFSET", "PULSES" })
  structures:register("MAZE",         { "METABOLISM", "OFFSET", "PROBABILITY" })
  structures:register("CRYPT",        { "INDEX", "LEVEL" })
  structures:register("VALE",         { "RANGE MIN", "RANGE MAX", "VELOCITY", "OUTPUT", "DURATION", "CHANNEL", "DEVICE" })
  structures:register("SOLARIUM",     { "CHARGE", "CAPACITY" })
  structures:register("UXB",          { "NOTES", "VELOCITY", "DURATION", "CHANNEL", "DEVICE" })
  structures:register("CASINO",       { "INDEX", "NOTE COUNT", "NOTES", "TOPOGRAPHY", "DURATION", "VELOCITY", "CHANNEL", "DEVICE" })
  structures:register("TUNNEL",       { "NETWORK" })
  structures:register("AVIARY",       { "NOTES", "CROW OUT" })
  structures:register("FOREST",       { "INDEX", "NOTE COUNT", "NOTES", "TOPOGRAPHY", "CROW OUT" })
  structures:register("HYDROPONICS",  { "METABOLISM", "OPERATOR", "TERRITORY" })
  structures:register("INSTITUTION",  { "CRUMBLE", "DEFLECT" })
  structures:register("MIRAGE",       { "METABOLISM", "DRIFT" })
  structures:register("SPOMENIK",     { "NOTES" })
  structures:register("AUTON",        { "INDEX", "NOTE COUNT", "NOTES", "TOPOGRAPHY" })
  structures:register("KUDZU",        { "METABOLISM", "RESILIENCE", "CRUMBLE" })
  structures:register("WINDFARM",     { "METABOLISM", "BEARING", "CLOCKWISE" })
  structures:register("FRACTURE",     { "NOTES", "RANGE MIN", "RANGE MAX", "OUTPUT", "DURATION", "CHANNEL", "DEVICE" })
  structures:register("CLOAKROOM",    { "TARGET", "PSYOP" } )
  structures:register("APIARY",       { "INDEX", "NOTE COUNT", "NOTES", "TOPOGRAPHY", "DURATION", "VELOCITY", "NB SELECT", "NB VOICE" })
end

function structures:register(name, attributes)
  table.insert(attributes, "DOCS")
  table.insert(attributes, "STRUCTURE")
  self.database[self.order] = {
    order = self.order,
    name = name,
    attributes = attributes,
    enabled = true
  }
  self.order = self.order + 1
end

function structures:scan()
  for k, v in pairs(self.database) do
    v.enabled = (params:get("structure_" .. v.name) == 1)
  end
end

function structures:delete_disabled()
  for k, v in pairs(self.database) do
    if not v.enabled then
       keeper:delete_all_structures(v.name)
    end
  end
end

function structures:first()
  return structures:all_enabled()[1].name
end

function structures:all_names()
  local out = {}
  for i, v in ipairs(self.database) do
    out[i] = v.name
  end
  return out
end

function structures:all_enabled()
  local out = {}
  for k, v in pairs(self.database) do
    if v.enabled then
      table.insert(out, v)
    end
  end
  return out
end

function structures:get_index(name)
  for i, v in ipairs(self:all_enabled()) do
    if v.name == name then
      return i
    end
  end
end

function structures:get_structure_attributes(name)
  for i, v in ipairs(self.database) do
    if name == v.name then
      return v.attributes
    end
  end
end

return structures