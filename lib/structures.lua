structures = {}

--[[

to add new structures, minimally:

 - structures:register() - this file
 - keeper:collision() - for business logic
 - new glyphs - automatically picked up via the string name

structure names must be a single word due to string matching for glyphs

]]

function structures.init()
  structures.order = 1
  structures.database = {}
  structures:register("HIVE",         { "METABOLISM", "OFFSET" })
  structures:register("SHRINE",       { "NOTES", "VELOCITY" })
  structures:register("GATE",         {})
  structures:register("RAVE",         { "METABOLISM", "OFFSET" })
  structures:register("TOPIARY",      { "INDEX", "NOTES", "VELOCITY" })
  structures:register("DOME",         { "METABOLISM", "OFFSET", "PULSES" })
  structures:register("MAZE",         { "METABOLISM", "OFFSET", "PROBABILITY" })
  structures:register("CRYPT",        { "INDEX", "LEVEL" })
  structures:register("VALE",         { "RANGE MIN", "RANGE MAX", "VELOCITY" })
  structures:register("SOLARIUM",     { "CHARGE", "CAPACITY" })
  structures:register("UXB",          { "NOTES", "VELOCITY", "DURATION", "CHANNEL", "DEVICE" })
  structures:register("CASINO",       { "INDEX", "NOTES", "DURATION", "CHANNEL", "VELOCITY", "DEVICE" })
  structures:register("TUNNEL",       { "NETWORK" })
  structures:register("AVIARY",       { "NOTES", "CROW OUT" })
  structures:register("FOREST",       { "INDEX", "NOTES", "CROW OUT" })
  structures:register("HYDROPONICS",  { "METABOLISM", "OPERATOR", "TERRITORY" })
  structures:register("INSTITUTION",  { "CRUMBLE", "DEFLECT" })
  structures:register("MIRAGE",       { "METABOLISM", "DRIFT" })
  structures:register("BANK",         { "NET INCOME", "INTEREST", "TAXES", "DEPRECIATE", "AMORTIZE" })
  structures:register("SPOMENIK",     { "INDEX", "NOTES" })
  structures:register("AUTON",        { "INDEX", "NOTES", })
end

function structures:register(name, attributes)
  table.insert(attributes, "DOCS")
  table.insert(attributes, "STRUCTURE")
  self.database[self.order] = {
    order = self.order,
    name = name,
    attributes = attributes
  }
  self.order = self.order + 1
end

function structures:all()
  local out = {}
  for i, v in ipairs(self.database) do
    out[i] = v.name
  end
  return out
end

function structures:get_structure_attributes(name)
  for i, v in ipairs(self.database) do
    if name == v.name then
      return v.attributes
    end
  end
end

return structures