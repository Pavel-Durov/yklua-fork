# Yk-enabled Lua

This is the reference Lua interpreter with the Yk JIT retrofitted.

This is experimental!

## Build

GNU make is required.

Run:
```shell
export PATH=/path/to/yk/bin:${PATH} # local path to https://github.com/ykjit/yk/blob/master/bin/yk-config (yk needs to be compiled)
export YK_BUILD_TYPE=<debug|release>
make
```

## Run

```shell
./src/lua -e "print('Hello World')" # execute program passed in as string
./src/lua ./tests/utf8.lua # execute lua program file 
./src/luac ./tests/utf8.lua -o ./utf8.out # translates lua programs into Lua bytecode
```

## Test

> Make sure to build the project first.

```shell
cd tests # navigate to tests directory
../src/lua -e"_U=true" db.lua # run single file
../src/lua -e"_U=true" all.lua # run complete test suite (Currently failing)
```

### Docker

```shell
run_docker_ci_job # local path to https://github.com/softdevteam/buildbot_config/blob/master/bin/run_docker_ci_job
```

### State of Tests

| Test           | Status  | Issue                                             | 
| -------------- | ------- | ------------------------------------------------- |
| api.lua        | Working |                                                   |
| bwcoercion.lua | Working |                                                   |
| closure.lua    | Working |                                                   |
| code.lua       | Working |                                                   |
| coroutine.lua  | Working |                                                   |
| events.lua     | Working |                                                   |
| files.lua      | Working |                                                   |
| gengc.lua      | Working |                                                   |
| goto.lua       | Working |                                                   |
| literals.lua   | Working |                                                   |
| pm.lua         | Working |                                                   |
| tpack.lua      | Working |                                                   |
| tracegc.lua    | Working |                                                   |
| utf8.lua       | Working |                                                   |
| vararg.lua     | Working |                                                   |
| db.lua         | Failing | [issue](https://github.com/ykjit/yklua/issues/38) |
| all.lua        | Failing |                                                   |
| attrib.lua     | Failing | [issue](https://github.com/ykjit/yklua/issues/42) |
| big.lua        | Failing |                                                   |
| bitwise.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/40) |
| strings.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/39) |
| calls.lua      | Failing | [issue](https://github.com/ykjit/yklua/issues/43) |
| constructs.lua | Failing | [issue](https://github.com/ykjit/yklua/issues/44) |
| cstack.lua     | Failing |                                                   |
| errors.lua     | Failing |                                                   |
| gc.lua         | Failing |                                                   |
| heavy.lua      | Failing |                                                   |
| locals.lua     | Failing |                                                   |
| main.lua       | Failing |                                                   |
| math.lua       | Failing |                                                   |
| nextvar.lua    | Failing |                                                   |
| sort.lua       | Failing |                                                   |
| verybig.lua    | Failing |                                                   |