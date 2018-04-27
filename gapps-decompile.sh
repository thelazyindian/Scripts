#!/bin/bash
cd /home/thug/opengapps-arm64/
git pull origin master
last_commit="https://github.com/opengapps/arm64/commit/$(git log --format="%H" -n 1)"
last_commit_date="$(git show -s --format=%cd --date=short)"
cd
readarray -t array <<< "$(find /home/thug/opengapps-arm64/ -name "*.apk" | awk -F '/' '{print $1"/"$2"/"$3"/"$4"/"$5"/"$6"/" }')"
appsdir=($(printf '%s\n' "${array[@]}" | sort -u))
#printf '%s\n' "${sorted[@]}"
for app in "${appsdir[@]}"; do
    cd $app
    readarray -t grepval <<< "$(find . -name "*.apk" | grep "nodpi")"
    #echo "Unpacking: "$app
    newdir="$(echo $app | sed 's@opengapps-arm64/app@opengapps-arm64-decompiled@g; s@opengapps-arm64/priv-app@opengapps-arm64-decompiled@g')"
    #find $(pwd)/opengapps-arm64/ -name "*.apk" -type f -exec sh -c '. ~/bro.sh'  {} \;
    for apk in "${grepval[@]}"; do
        if [[ -z "${apk/ }" ]]; then
            readarray -t array2 <<< "$(find . -name "*.apk")"
            appsdir2=($(printf '%s\n' "${array2[@]}" | sort -u))
            for app2 in "${appsdir2[@]}"; do
                decompile_dir="$(echo $newdir""$app2 | sed 's%/[^/]*$%/%')"
                echo ""
                echo "empty"
                echo "Unpacking: "$app""$app2
                echo "To Dir: "$decompile_dir
                #echo "New Dir: "$newdir
                echo ""
                rm -rf "$newdir"
                apktool d $app2 -o $decompile_dir -s -f
            done
        else
            decompile_dir="$(echo $newdir""$apk | sed 's%/[^/]*$%/%')"
            echo ""
            echo "Unpacking: "$app""$apk
            echo "To Dir: "$decompile_dir
            #echo "New Dir: "$newdir
            echo ""
            rm -rf "$newdir"
            apktool d $apk -o $decompile_dir -s -f
        fi
    done
    printf '%s\n' "${grepval[@]}"
    cd
done
cd /home/thug/opengapps-arm64-decompiled/
find . -name "*.yml" -type f -exec rm -rf "{}" \;
find . -name "*.dex" -type f -exec rm -rf "{}" \;
find . -name "unknown" -type d -exec rm -rf "{}" \;
find . -name "lib" -type d -exec rm -rf "{}" \;
find . -name "original" -type d -exec rm -rf "{}" \;
git add -A
git commit -m "Update: $last_commit_date" -m "Last Commit: $last_commit"
git push origin master
cd
