filesystem = {}

function filesystem.init()
  filesystem.paths = {}
  filesystem.paths["save_path"] = config.settings.save_path
  filesystem.paths["crypt_path"] = config.settings.crypt_path
  for k,path in pairs(filesystem.paths) do
    if util.file_exists(path) == false then
      util.make_dir(path)
    end
  end
end

function filesystem:get_crypt()
  return self.paths.crypt_path
end

return filesystem