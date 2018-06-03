#!/bin/bash

HOME_DIR=/home/thug # Must be in the format /home/username (only 2 dir structure) for this script to work properly
APKTOOL=/usr/local/bin/apktool # Apktool path
GAPPS_DECOMPILE_DIR=opengapps-arm64-decompiled
GAPPS_PUSH_SSH_URL=git@github.com:ThemersHub/DecompiledApps
GAPPS_CLONE_DIR=opengapps-arm64

function checkApktool()
{
    if [ ! -e $APKTOOL ]; then
        echo "Apktool not found!"
        echo "Installing"
        cd $HOME_DIR
        mkdir apktool && cd apktool
        APKTOOL=`pwd`"/apktool"
        wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.3.jar
        mv apktool_2.3.3.jar apktool.jar
        wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
        chmod +x *
        export PATH=$PATH:`pwd`
        cd
    fi
}

function rmvShits()
{
    # Remove useless files
    find . -name "*.yml" -type f -exec rm -rf "{}" \;
    find . -name "*.dex" -type f -exec rm -rf "{}" \;
    find . -name "unknown" -type d -exec rm -rf "{}" \;
    find . -name "lib" -type d -exec rm -rf "{}" \;
    find . -name "original" -type d -exec rm -rf "{}" \;
}

function decompileApk()
{
    echo ""
    decompile_dir="$(echo $newdir""$1 | sed 's%/[^/]*$%/%')"
    appname="$(echo $decompile_dir | awk -F '/' '{print $5}')"
    echo "START Working on: $appname"
    echo "Unpacking: "$app""$1
    echo "To Dir: "$decompile_dir
    rm -rf "$decompile_dir"
    $APKTOOL d $1 -o $decompile_dir -s -f
    cd $HOME_DIR/$GAPPS_DECOMPILE_DIR/
    rmvShits
    if [ -z "$(git status --porcelain)" ]; then
        echo "No changes to this"
    else
        echo "Changes have been made. Commiting now..."
        git add -A
        git commit -m "Update $appname"
        changesMade=1
    fi
    echo "END Working on: $appname"
    echo ""
}

function startDecompile()
{
    cd $HOME_DIR/
    rm -rf $HOME_DIR/$GAPPS_CLONE_DIR/
    git clone $GAPPS_SSH_URL -b master $HOME_DIR/$GAPPS_CLONE_DIR/ --depth 1
    git clone $GAPPS_PUSH_SSH_URL -b master $HOME_DIR/$GAPPS_DECOMPILE_DIR/
    cd $HOME_DIR/$GAPPS_CLONE_DIR/
    #git pull origin master
    last_commit="$GAPPS_HTTPS_URL/commit/$(git log --format="%H" -n 1)"
    last_commit_date="$(git show -s --format=%cd --date=short)"
    cd $HOME_DIR/$GAPPS_DECOMPILE_DIR/
    changesMade=0
    git commit --allow-empty -m "START: Update: $last_commit_date Repo: $GAPPS_HTTPS_URL" -m "Last Commit: $last_commit"
    cd
    readarray -t array <<< "$(find $HOME_DIR/$GAPPS_CLONE_DIR/ -name "*.apk" | awk -F '/' '{print $1"/"$2"/"$3"/"$4"/"$5"/"$6"/" }')"
    appsdir=($(printf '%s\n' "${array[@]}" | sort -u))
    #printf '%s\n' "${sorted[@]}"
    for app in "${appsdir[@]}"; do
        cd $app
        readarray -t grepval <<< "$(find . -name "*.apk" | grep "nodpi")"
        newdir="$(echo $app | sed 's@$GAPPS_CLONE_DIR/app@$GAPPS_DECOMPILE_DIR@g; s@$GAPPS_CLONE_DIR/priv-app@$GAPPS_DECOMPILE_DIR@g')"
        for apk in "${grepval[@]}"; do
            if [[ -z "${apk/ }" ]]; then
                readarray -t array2 <<< "$(find . -name "*.apk")"
                appsdir2=($(printf '%s\n' "${array2[@]}" | sort -u))
                for app2 in "${appsdir2[@]}"; do
                    decompileApk $app2
                done
            else
                decompileApk $apk
            fi
        done
        printf '%s\n' "${grepval[@]}"
        cd
    done
    cd $HOME_DIR/$GAPPS_DECOMPILE_DIR/
    if [[ "$changesMade" -eq 1 ]]; then
        git commit --allow-empty -m "END: Update: $last_commit_date Repo: $GAPPS_HTTPS_URL" -m "Last Commit: $last_commit"
        git push origin master
    else
        git reset --hard HEAD~1 # Undo's the START commit if there are no updates to any of the apps hence no update commmits
    fi
    cd
    rm -rf $HOME_DIR/$GAPPS_CLONE_DIR/
}

# Run a check to ensure apktool exist, if not then install it
checkApktool

if [ -e "$(command -v git)" ]; then
    # Decompile opengapps/arm64 repo
    GAPPS_HTTPS_URL=https://github.com/opengapps/arm64
    GAPPS_SSH_URL=git@github.com:opengapps/arm64
    startDecompile

    # Decompile opengapps/all repo
    GAPPS_HTTPS_URL=https://github.com/opengapps/all
    GAPPS_SSH_URL=git@github.com:opengapps/all
    startDecompile
else
    echo "Install and configure git"
fi