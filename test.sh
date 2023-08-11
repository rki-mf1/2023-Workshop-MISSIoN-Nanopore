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

# Add a few commands to the start of the script
cat<<-'EOF'>hands-on.sh
# Setup conda/mamba
eval "$(conda shell.bash hook)"
# Abort script on any failed command, output the commands to the cli
set -ex
EOF

cat ../day*/{hands-on,solutions}.md | codedown bash | grep -v "\&$" >> hands-on.sh
bash hands-on.sh
