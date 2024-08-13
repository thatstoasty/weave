#!/bin/bash
mkdir -p tmp

echo -e "Building weave package and copying tests."
./scripts/build.sh package
mv weave.mojopkg tmp/
cp -R tests/ tmp/tests/

echo -e "\nBuilding binaries for all examples."
pytest tmp/tests

echo -e "Cleaning up the test directory."
rm -R tmp
