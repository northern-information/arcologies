filesystem = {}

function filesystem.init()
  filesystem.paths = {}
  filesystem.paths["save_path"] = config.settings.save_path
  filesystem.paths["crypt_path"] = config.settings.crypt_path
  filesystem.paths["crypts_path"] = config.settings.crypts_path
  for k,path in pairs(filesystem.paths) do
    if util.file_exists(path) == false then
      util.make_dir(path)
    end
  end
  -- crypt(s)
  filesystem.crypts_names = { config.settings.crypt_default_name }
  filesystem.crypt_default_path = filesystem.paths.crypt_path
  filesystem.current = filesystem.crypt_default_path
  filesystem:scan_crypts()
end

function filesystem.load(path)
   if string.find(path, "arcology") ~= nil then
    print("loading...")
    local data = tab.load(path)
    if data ~= nil then
      print("data found")
      fn.load(data)
      params:read(norns.state.data .. data.arcology_name ..".pset")
      print ('loaded ' .. norns.state.data .. data.arcology_name)
    else
      print("no data")
    end
  end
end

function filesystem.save(text)
  if text then
    print("saving...")
    local save_path = norns.state.data .. text
    tab.save(fn.collect_data_for_save(text), save_path ..".arcology")
    params:write(save_path .. ".pset")
    print("saved!")
  else
    print("save cancel")
  end
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

function filesystem:set_crypt(index)
  if index == 1 then
    self.current = self.crypt_default_path
    self.crypt_name = "DEFAULT"
  else
    self.current = self.paths.crypts_path .. self.crypts_names[index] .. "/"
    self.crypt_name = self.crypts_names[index]
  end
  if init_done then
    keeper:update_all_crypts()
  end
end

function filesystem:load_crypt_by_name(name)
  local result = fn.table_find(self.crypts_names, name)
  params:set("crypts_directory", result or 1)
end

function filesystem:get_crypt()
  return self.current
end

return filesystem