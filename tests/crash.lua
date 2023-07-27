local dofile = function ()
  local f = assert(loadfile('main_crash.lua'))
  local b = string.dump(f)
  f = assert(load(b))
  return f()
end

dofile()

-- works:
-- dofile('main_crash.lua') 

-- loadProtos(f)
-- b src/lcode.c:407 -- Assign Location for Loops
-- b src/ldo.c:979 -- Text compilation
-- b luaU_dump
