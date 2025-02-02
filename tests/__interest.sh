#!/bin/bash
# set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input.lua>"
    exit 1
fi
INPUT="$1"
LUA_EXEC="$SCRIPT_DIR/../src/lua"
if [ ! -x "$LUA_EXEC" ]; then
    echo "Error: Lua executable not found at '$LUA_EXEC'"
    exit 1
fi
export LUA_PATH="$SCRIPT_DIR/libs/?.so;$SCRIPT_DIR/libs/?.lua;$SCRIPT_DIR/?.lua;;"
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' does not exist."
    exit 1
fi
# Create a unique temporary log file
LOG_FILE=./log.shrinkray.log
# Run the Lua script and capture output
RUST_BACKTRACE=full YKD_OPT=0 YKD_SERIALISE_COMPILATION=1 "$LUA_EXEC" -e "_U=true" "$INPUT" > "$LOG_FILE" 2>&1


# First check: is the file syntactically valid? (using luac)
# if ! luac -p "$INPUT" 2>/dev/null; then
#     echo "not interesting (syntax error)."
#     rm "$LOG_FILE"
#     exit 1
# fi
# Define the error pattern to search for
ERROR_PATTERN="attempt to call a boolean value (field 'resume')"
if grep -q "$ERROR_PATTERN" "$LOG_FILE"; then
    echo "interesting!"
    echo "$ERROR_PATTERN"
    # rm "$LOG_FILE"
    exit 0
else
    echo "not interesting."
    # rm "$LOG_FILE"
    exit 1
fi
