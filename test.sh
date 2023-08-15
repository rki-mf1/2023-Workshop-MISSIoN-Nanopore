#!/usr/bin/env bash

echo "Starting a test run. Working data and environments will be placed in ./auto-test/"
sleep 2

# Install codedown
eval "$(conda shell.bash hook)"
mamba create -y -p ./.codedown nodejs
conda activate ./.codedown
npm install -g codedown

# Copy cached downloads into the right place
find day* -name "hands-on.md" -print0 -o -name "solutions.md" -print0 | sort -z | xargs -0 cat | codedown bash | grep "wget" > download-new.sh
if [ -f download.sh ]; then
  # If the download scripts have changed then we have to invalidate the download cache
  cmp --silent download.sh download-new.sh || mv downloads downloads.old && echo "The set of files to download has changed. Invalidating the cache (./downloads/)"
fi
mv download-new.sh download.sh
if [ ! -d "downloads" ]; then
  echo "Downloading all files into the cache (./downloads/)"
  mkdir -p downloads
  cd downloads
  bash -x ../download.sh
  cd -
fi

mkdir -p auto-test
cd auto-test
cp -r ../downloads/* .
# Add a few commands to the start of the script
cat<<-'EOF'>hands-on.sh
# Setup conda/mamba
eval "$(conda shell.bash hook)"
# Abort script on any failed command, output the commands to the cli
set -ex
EOF
find ../day* -name "hands-on.md" -print0 -o -name "solutions.md" -print0 | sort -z | xargs -0 cat | codedown bash | grep -v "\&$" | grep -v "^wget" >> hands-on.sh
bash hands-on.sh
