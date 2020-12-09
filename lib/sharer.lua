local sharer={}

local CCDATA_DIR=_path.data.."arcologies/"

function sharer.init()
  script_name = "arcologies"
  -- only continue if norns.online exists
  if not util.file_exists(_path.code.."norns.online") then
    print("need to donwload norns.online")
    do return end
  end

  -- prevents initial bang for reloading directory
  preventbang=true
  clock.run(function()
    clock.sleep(2)
    preventbang=false 
  end)

  -- load norns.online lib
  local share=include("norns.online/lib/share")

  -- start uploader with name of your script
  local uploader=share:new{script_name=script_name}
  if uploader==nil then
    print("uploader failed, no username?")
    do return end
  end

  -- add parameters
  params:add_group("SHARE",4)

  -- uploader (CHANGE THIS TO FIT WHAT YOU NEED)
  -- select a save from the names folder
  params:add_file("share_upload","upload",CCDATA_DIR)
  params:set_action("share_upload",function(y)
    -- prevent banging
    local x=y
    params:set("share_download",CCDATA_DIR)
    if #x<=#CCDATA_DIR then
      do return end
    end

    -- choose data name
    -- (here dataname is from the selector)
    local dataname=share.trim_prefix(x,CCDATA_DIR)
    dataname=dataname:gsub("%.arcology","") -- remove suffix
    dataname=dataname:gsub("%.pset","") -- remove suffix
    params:set("share_message","uploading...")
    _menu.redraw()
    print("uploading "..x.." as "..dataname)

    -- upload arcology file
    target=CCDATA_DIR..uploader.upload_username.."-"..dataname..".arcology"
    pathtofile=CCDATA_DIR..dataname..".arcology"
    msg=uploader:upload{dataname=dataname,pathtofile=pathtofile,target=target}

    -- upload pset file
    target=CCDATA_DIR..uploader.upload_username.."-"..dataname..".pset"
    pathtofile=CCDATA_DIR..dataname..".pset"
    msg=uploader:upload{dataname=dataname,pathtofile=pathtofile,target=target}

    -- goodbye
    params:set("share_message","uploaded.")
  end)

  -- downloader
  download_dir=share.get_virtual_directory(script_name)
  params:add_file("share_download","download",download_dir)
  params:set_action("share_download",function(y)
    -- prevent banging
    local x=y
    params:set("share_download",download_dir)
    if #x<=#download_dir then
      do return end
    end

    -- download
    print("downloading!")
    params:set("share_message","downloading...")
    _menu.redraw()
    local msg=share.download_from_virtual_directory(x)
    params:set("share_message",msg)
  end)

  -- add a button to refresh the directory
  params:add{type='binary',name='refresh directory',id='share_refresh',behavior='momentary',action=function(v)
    if preventbang then
      do return end
    end
    print("updating directory")
    params:set("share_message","refreshing directory.")
    _menu.redraw()
    share.make_virtual_directory()
    params:set("share_message","directory updated.")
  end
}
params:add_text('share_message',">","")
end



sharer.trim_prefix=function(s,p)
  local t=(s:sub(0,#p)==p) and s:sub(#p+1) or s
  return t
end


return sharer
