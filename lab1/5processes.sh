#!/bin/bash

pss=$(ps au | awk ' {print $2,$3,$4,$11}' )

splited="$(cut -d '\n' -f2 <<<"$pss")"

for line in $splited
do
    echo "> [$line]"
done


