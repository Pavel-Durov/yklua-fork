#!/env/sh

for f in *.lua; do
  echo "Processing $f file..."
  if [ "$f" == "all.lua" ]; then
    continue
  fi
  ../src/lua $f
done