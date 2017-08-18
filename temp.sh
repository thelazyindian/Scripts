INPUT=$1

words=$(echo $INPUT | tr "/" "\n")
repo=""
del="_"
i=0
j=1
for word in $words
    do
     i=$(($i+$j))
     if [ "$i" -eq "$j" ]; then
     repo=$(echo $INPUT | cut -d'/' -f $i)
     else
     repo=$repo$del$(echo $INPUT | cut -d'/' -f $i)
     fi
    done
echo $repo
