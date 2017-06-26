#!/bin/bash
sudo apt install -y python-software-properties
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
git clone https://github.com/c9/core sdk
cd sdk
./scripts/install-sdk.sh
#node server.js -p 80 -l 0.0.0.0 -a username:pass
