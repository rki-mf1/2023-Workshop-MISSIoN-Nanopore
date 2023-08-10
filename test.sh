#!/usr/bin/env bash

echo "Starting a test run. Working data and environments will be placed in ./auto-test/"
sleep 2

mkdir -p auto-test
cd auto-test

# Install codedown
eval "$(conda shell.bash hook)"
mamba create -y -p ./.codedown nodejs
conda activate ./.codedown
npm install -g codedown

echo 'eval "$(conda shell.bash hook)"' > hands-on.sh
cat ../day*/hands-on.md | codedown bash | grep -v "\&$" >> hands-on.sh
set -e
bash -x hands-on.sh
