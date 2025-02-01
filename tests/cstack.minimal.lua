do    -- bug since 5.4.0
  local count = 0
  print("chain of 'coroutine.close'")
  -- create N coroutines forming a list so that each one, when closed,
  -- closes the previous one. (With a large enough N, previous Lua
  -- versions crash in this test.)
  local coro = false
  for i = 1, 1000 do
    local previous = coro
    coro = coroutine.create(function()
      local cc <close> = setmetatable({}, {__close=function()
        count = count + 1
        if previous then
          assert(coroutine.close(previous))
        end
      end})
      coroutine.yield()   -- leaves 'cc' pending to be closed
    end)
    assert(coroutine.resume(coro))  -- start it and run until it yields
  end
  local st, msg = coroutine.close(coro)
  assert(not st and string.find(msg, "C stack overflow"))
  print("final count: ", count)
end