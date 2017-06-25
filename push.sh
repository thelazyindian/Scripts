#!/bin/bash

# Echo command while getting executed
set -x

# Save current directory
cur=$PWD

# Save command line arguments so functions can access it
args=("$@")

# To access command line arguments use syntax ${args[1]} etc
function dir_command {
    cd $1
    echo "$(tput setaf 2)$1$(tput sgr 0)"
#    git tag -a ${args[0]} -m "${args[1]}"
#    git push --tags
#    git remote -v
    git checkout n-8916
    git push ctr n-8916
    cd ..
}

#This loop will go to each immediate child and execute dir_command
#find . -maxdepth 1 -type d \( ! -name . \) | while read dir; do
#   dir_command "$dir/"
#done

# Loops through given set of folders
declare -a dirs=('art' 'external/skia' 'frameworks/native' 'frameworks/opt/telephony' 'packages/apps/Bluetooth' 'packages/apps/Settings' 'packages/services/Telecomm' 'packages/services/Telephony' 'system/bt' 'system/core' 'frameworks/av' 'frameworks/base')
for dir in "${dirs[@]}"; do
    dir_command "$cur/$dir/"
done

# Restore work folder
cd "$cur"

#These commands store credentials for git for given time
#git config --global credential.helper store
#git config --global credential.helper 'cache --timeout=3600'
