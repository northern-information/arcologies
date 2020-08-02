-- k1: exit  e1: navigate
--
--
--      e2: select    e3: change
--
--    k2: play      k3: delete
--
--
-- ........................................
-- l.llllllll.co/arcologies
-- <3 @tyleretters
-- v0.0.1

local core = include("lib/core")

function init()
  core.init()
end

function key(n,z)
  core.key(n,z)
end

function enc(n,d)
  core.enc(n,d)
end

function redraw()
  core.redraw()
end

function cleanup()
  core.cleanup()  
end