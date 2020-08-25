filesystem = {}

function filesystem.init()
  filesystem.paths = {}
  filesystem.paths["save_path"] = config.settings.save_path
  filesystem.paths["crypt_path"] = config.settings.crypt_path
  filesystem.paths["crypts_path"] = config.settings.crypts_path
  filesystem.crypts_names = {}
  filesystem.default = filesystem.paths.crypt_path
  filesystem.current = filesystem.default
  for k,path in pairs(filesystem.paths) do
    if util.file_exists(path) == false then
      util.make_dir(path)
    end
  end
  filesystem:scan_crypts()
end

function filesystem:scan_crypts()
  local delete = {"LICENSE", "README.md"}
  local scan = util.scandir(self.paths.crypts_path)
  for k, file in pairs(scan) do
    for kk, d in pairs(delete) do
      local find = fn.table_find(scan, d)
      if find then table.remove(scan, find) end
    end
    local name = string.gsub(file, "/", "")
    table.insert(self.crypts_names, name)
  end
end

function filesystem:set_crypt(name)
  if name == "default" then
    self.current = self.default
  else
    self.current = self.paths.crypts_path .. name .. "/"
  end
end

function filesystem:get_crypt()
  return self.current
end

return filesystem