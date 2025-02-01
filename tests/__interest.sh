#!/bin/bash

# Determine the directory where the script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input.lua>"
    exit 1
fi

INPUT="$1"

# Define the path to the 'lua' executable relative to the script's directory
LUA_EXEC="$SCRIPT_DIR/../src/lua"

# Verify that the 'lua' executable exists and is executable
if [ ! -x "$LUA_EXEC" ]; then
    echo "Error: Lua executable not found at '$LUA_EXEC'"
    exit 1
fi

# Set LUA_PATH to include the 'libs' directory
export LUA_PATH="$SCRIPT_DIR/libs/?.so;$SCRIPT_DIR/libs/?.lua;$SCRIPT_DIR/?.lua;;"

# Verify that the input Lua script exists
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' does not exist."
    exit 1
fi

RUST_BACKTRACE=full YKD_OPT=0 YKD_SERIALISE_COMPILATION=1 \
"$LUA_EXEC" -e "_U=true" "$INPUT" > "$SCRIPT_DIR/test_output.log" 2>&1

# Define the error pattern to search for
ERROR_PATTERN="attempt to call a boolean value (field 'resume')"


echo "Error pattern: $ERROR_PATTERN"

# Check if the error pattern exists in the output
if grep -q "$ERROR_PATTERN" "$SCRIPT_DIR/test_output.log"; then
    echo "interesting!"
    exit 0
else
    echo "not interesting."
    exit 1
fi
