local dofile = function ()
  local f = assert(loadfile('main_crash.lua'))
  local b = string.dump(f)
  f = assert(load(b))
  return f()
end

dofile()
