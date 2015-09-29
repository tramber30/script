#!/bin/bash

echo "clear remaining proxy settings:"
for i in $(env | grep -i "proxy" | cut -d = -f1);
do 
	echo "$i="
        export $i=""
done
