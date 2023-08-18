#!/bin/bash

COUNT=$(find . -name '*.txt' -exec basename {} \; | cut -d "." -f 1 | wc -l)

for i in $COUNT; do
    FILE=$(find . -name '*.txt' -exec basename {} \; | cut -d "." -f 1 | head -n"$i")
    FIND=$(find . -name \""$FILE"\")
    echo "$FIND"
done


