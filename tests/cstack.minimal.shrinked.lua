do for A = 0, 1 / 0 do
    A = coroutine.create(function() coroutine.yield() end)
    assert(coroutine.resume(A))
  end end
