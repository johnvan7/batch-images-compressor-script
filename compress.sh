#!/bin/bash
function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

target_ext=${1:-"JPG"}

FILES="./*.$target_ext"
count=$(ls -dq *.$target_ext | wc -l)

echo "Found $count .$target_ext files"
if [ "$count" -eq "0" ]; then
   exit 0
fi

mkdir compressed &> /dev/null

index=0
for f in $FILES 
do
   ((index=index+1))
   ffmpeg -i $f -qscale:v 25 ./compressed/$f -v warning -n
   ProgressBar ${index} ${count}
done

printf '\nFinished!\n'
