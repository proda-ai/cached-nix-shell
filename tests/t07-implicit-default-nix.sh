#!/bin/sh
. ./lib.sh

put +x ./tmp/lua.nix << 'EOF'
with import <nixpkgs> { }; mkShell { buildInputs = [ lua ]; }
EOF

put +x ./tmp/luajit.nix << 'EOF'
with import <nixpkgs> { }; mkShell { buildInputs = [ luajit ]; }
EOF

mkdir -p ./tmp/foo
cp ./tmp/lua.nix ./tmp/foo/default.nix
# ./tmp/foo is a directory containing ./tmp/foo/default.nix

run cached-nix-shell ./tmp/foo --run 'lua -v'
check_contains "Lua.org"
check_slow


rm -rf ./tmp/foo
cp ./tmp/luajit.nix ./tmp/foo
# now ./tmp/foo is a plain .nix file

run cached-nix-shell ./tmp/foo --run 'lua -v'
check_contains "http://luajit.org/"
check_slow


rm -rf ./tmp/foo
mkdir -p ./tmp/foo
cp ./tmp/lua.nix ./tmp/foo/default.nix
# now ./tmp/foo is a directory containing ./tmp/foo/default.nix (again)

run cached-nix-shell ./tmp/foo --run 'lua -v'
check_contains "Lua.org"
check_fast
