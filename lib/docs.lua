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
  "github.com/",
  " tyleretters/",
  " arcologies-docs",
  "",
  "l.llllllll.co/",
  " arcologies"
}

return docs