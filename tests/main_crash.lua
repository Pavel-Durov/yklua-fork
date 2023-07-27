function my_function (my_limit)
  for i = 0, my_limit do
    print(i)
  end
  -- for i = 0, my_limit do
  --   print(i)
  -- end
  -- for i = 0, my_limit do
  --   print(i)
  -- end
end

my_function(1)

-- loadProtos(f) -> leads to crash
-- b src/lcode.c:408
-- b src/lcode.c:408

-- first call

-- #0  luaK_code (fs=<optimised out>, i=<optimised out>) at lcode.c:408
-- #1  0x0000000000833c77 in luaK_codeABx (fs=0x7ffff249bfd8, o=<optimised out>, a=<optimised out>, bc=<optimised out>) at lcode.c:436
-- #2  0x0000000000828986 in forbody (ls=0x7ffff249be70, base=1, line=<optimised out>, nvars=<optimised out>, isgen=<optimised out>) at lparser.c:1562
-- #3  0x0000000000827a90 in fornum (ls=0x7ffff249be70, varname=<optimised out>, line=2) at lparser.c:1587
-- #4  0x000000000081aa43 in forstat (ls=0x7ffff249be70, line=2) at lparser.c:1628
-- #5  0x00000000008196e4 in statement (ls=0x7ffff249be70) at lparser.c:1867
-- #6  0x000000000081639e in statlist (ls=0x7ffff249be70) at lparser.c:805
-- #7  0x0000000000821281 in body (ls=0x7ffff249be70, e=<optimised out>, ismethod=<optimised out>, line=<optimised out>) at lparser.c:1003
-- #8  0x000000000081b426 in funcstat (ls=0x7ffff249be70, line=1) at lparser.c:1787
-- #9  0x00000000008197b4 in statement (ls=0x7ffff249be70) at lparser.c:1875
-- #10 0x000000000081639e in statlist (ls=0x7ffff249be70) at lparser.c:805
-- #11 0x00000000008157b1 in mainfunc (ls=0x7ffff249be70, fs=<optimised out>) at lparser.c:1935
-- #12 0x00000000008153aa in luaY_parser (L=0x90d248, z=0x7ffff249bbf8, buff=<optimised out>, dyd=<optimised out>, name=<optimised out>, firstchar=<optimised out>) at lparser.c:1960
-- #13 0x00000000007f7683 in f_parser (L=0x90d248, ud=<optimised out>) at ldo.c:973
-- #14 0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7f7270 <f_parser>, ud=0x7ffff249bc60) at ldo.c:144
-- #15 0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7f7270 <f_parser>, u=0x7ffff249bc60, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #16 0x00000000007f7061 in luaD_protectedparser (L=0x90d248, z=<optimised out>, name=<optimised out>, mode=<optimised out>) at ldo.c:990
-- #17 0x00000000007e0878 in lua_load (L=0x90d248, reader=<optimised out>, data=<optimised out>, chunkname=0x915188 "@main_crash.lua", mode=0x0) at lapi.c:1097
-- #18 0x0000000000888f79 in luaL_loadfilex (L=0x90d248, filename=<optimised out>, mode=0x0) at lauxlib.c:800
-- #19 0x000000000088e8ae in luaB_loadfile (L=0x90d248) at lbaselib.c:344
-- #20 0x00000000007f3155 in precallC (L=0x90d248, func=<optimised out>, nresults=<optimised out>, f=0x88e730 <luaB_loadfile>) at ldo.c:506
-- #21 0x00000000007f37a8 in luaD_precall (L=0x90d248, func=0x90da40, nresults=1) at ldo.c:572
-- #22 0x000000000087a60c in luaV_execute (L=0x90d248, ci=<optimised out>) at lvm.c:1667
-- #23 0x00000000007f421b in ccall (L=0x90d248, func=<optimised out>, nResults=<optimised out>, inc=<optimised out>) at ldo.c:609
-- #24 0x00000000007f4364 in luaD_callnoyield (L=0x90d248, func=0x90da20, nResults=-1) at ldo.c:629
-- #25 0x00000000007e05e3 in f_call (L=0x90d248, ud=<optimised out>) at lapi.c:1041
-- #26 0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7e0520 <f_call>, ud=0x7ffff2499308) at ldo.c:144
-- #27 0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7e0520 <f_call>, u=0x7ffff2499308, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #28 0x00000000007e00cc in lua_pcallk (L=0x90d248, nargs=<optimised out>, nresults=<optimised out>, errfunc=<optimised out>, ctx=<optimised out>, k=<optimised out>) at lapi.c:1067
-- #29 0x00000000007d1d03 in docall (L=0x90d248, narg=0, nres=-1) at lua.c:160
-- #30 0x00000000007d1404 in handle_script (L=0x90d248, argv=<optimised out>) at lua.c:255
-- #31 0x00000000007cf6c6 in pmain (L=0x90d248) at lua.c:637
-- #32 0x00000000007f3155 in precallC (L=0x90d248, func=<optimised out>, nresults=<optimised out>, f=0x7ceee0 <pmain>) at ldo.c:506
-- #33 0x00000000007f37a8 in luaD_precall (L=0x90d248, func=0x90d9e0, nresults=1) at ldo.c:572
-- #34 0x00000000007f415f in ccall (L=0x90d248, func=0x90d9e0, nResults=1, inc=<optimised out>) at ldo.c:607
-- --Type <RET> for more, q to quit, c to continue without paging--
-- #35 0x00000000007f4364 in luaD_callnoyield (L=0x90d248, func=0x90d9e0, nResults=1) at ldo.c:629
-- #36 0x00000000007e05e3 in f_call (L=0x90d248, ud=<optimised out>) at lapi.c:1041
-- #37 0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7e0520 <f_call>, ud=0x7ffff2499058) at ldo.c:144
-- #38 0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7e0520 <f_call>, u=0x7ffff2499058, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #39 0x00000000007e00cc in lua_pcallk (L=0x90d248, nargs=<optimised out>, nresults=<optimised out>, errfunc=<optimised out>, ctx=<optimised out>, k=<optimised out>) at lapi.c:1067
-- #40 0x00000000007ceb9e in main (argc=<optimised out>, argv=0x7fffffffd208) at lua.c:664


-- second call

-- #1  0x00000000008585a7 in loadProtos (S=<optimised out>, f=<optimised out>) at lundump.c:199
-- #2  0x0000000000856c01 in loadFunction (S=0x7ffff2499e58, f=0x9141c0, psource=<optimised out>) at lundump.c:268
-- #3  0x0000000000856107 in luaU_undump (L=<optimised out>, Z=<optimised out>, name=<optimised out>) at lundump.c:328
-- #4  0x00000000007f74f3 in f_parser (L=0x90d248, ud=<optimised out>) at ldo.c:969
-- #5  0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7f7270 <f_parser>, ud=0x7ffff2499c60) at ldo.c:144
-- #6  0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7f7270 <f_parser>, u=0x7ffff2499c60, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #7  0x00000000007f7061 in luaD_protectedparser (L=0x90d248, z=<optimised out>, name=<optimised out>, mode=<optimised out>) at ldo.c:990
-- #8  0x00000000007e0878 in lua_load (L=0x90d248, reader=<optimised out>, data=<optimised out>, chunkname=0x9140b8 "\033LuaT", mode=0x25516e "bt") at lapi.c:1097
-- #9  0x0000000000889e81 in luaL_loadbufferx (L=0x90d248, buff=<optimised out>, size=<optimised out>, name=0x9140b8 "\033LuaT", mode=0x25516e "bt") at lauxlib.c:833
-- #10 0x000000000088ec91 in luaB_load (L=0x90d248) at lbaselib.c:395
-- #11 0x00000000007f3155 in precallC (L=0x90d248, func=<optimised out>, nresults=<optimised out>, f=0x88e950 <luaB_load>) at ldo.c:506
-- #12 0x00000000007f37a8 in luaD_precall (L=0x90d248, func=0x90da60, nresults=1) at ldo.c:572
-- #13 0x000000000087a60c in luaV_execute (L=0x90d248, ci=<optimised out>) at lvm.c:1667
-- #14 0x00000000007f421b in ccall (L=0x90d248, func=<optimised out>, nResults=<optimised out>, inc=<optimised out>) at ldo.c:609
-- #15 0x00000000007f4364 in luaD_callnoyield (L=0x90d248, func=0x90da20, nResults=-1) at ldo.c:629
-- #16 0x00000000007e05e3 in f_call (L=0x90d248, ud=<optimised out>) at lapi.c:1041
-- #17 0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7e0520 <f_call>, ud=0x7ffff2499308) at ldo.c:144
-- #18 0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7e0520 <f_call>, u=0x7ffff2499308, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #19 0x00000000007e00cc in lua_pcallk (L=0x90d248, nargs=<optimised out>, nresults=<optimised out>, errfunc=<optimised out>, ctx=<optimised out>, k=<optimised out>) at lapi.c:1067
-- #20 0x00000000007d1d03 in docall (L=0x90d248, narg=0, nres=-1) at lua.c:160
-- #21 0x00000000007d1404 in handle_script (L=0x90d248, argv=<optimised out>) at lua.c:255
-- #22 0x00000000007cf6c6 in pmain (L=0x90d248) at lua.c:637
-- #23 0x00000000007f3155 in precallC (L=0x90d248, func=<optimised out>, nresults=<optimised out>, f=0x7ceee0 <pmain>) at ldo.c:506
-- #24 0x00000000007f37a8 in luaD_precall (L=0x90d248, func=0x90d9e0, nresults=1) at ldo.c:572
-- #25 0x00000000007f415f in ccall (L=0x90d248, func=0x90d9e0, nResults=1, inc=<optimised out>) at ldo.c:607
-- #26 0x00000000007f4364 in luaD_callnoyield (L=0x90d248, func=0x90d9e0, nResults=1) at ldo.c:629
-- #27 0x00000000007e05e3 in f_call (L=0x90d248, ud=<optimised out>) at lapi.c:1041
-- #28 0x00000000007ee2c7 in luaD_rawrunprotected (L=0x90d248, f=0x7e0520 <f_call>, ud=0x7ffff2499058) at ldo.c:144
-- #29 0x00000000007f6b06 in luaD_pcall (L=0x90d248, func=0x7e0520 <f_call>, u=0x7ffff2499058, old_top=<optimised out>, ef=<optimised out>) at ldo.c:928
-- #30 0x00000000007e00cc in lua_pcallk (L=0x90d248, nargs=<optimised out>, nresults=<optimised out>, errfunc=<optimised out>, ctx=<optimised out>, k=<optimised out>) at lapi.c:1067
-- #31 0x00000000007ceb9e in main (argc=<optimised out>, argv=0x7fffffffd208) at lua.c:664