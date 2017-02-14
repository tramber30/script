#!/bin/bash

source ~/local_variable.sh

echo "set default boot entry"
MENU_ENTRY_NB=$(grep ^menuentry /etc/grub2-efi.cfg | wc -l)

echo "MENU_ENTRY_NUM:" $MENU_ENTRY_NB

index=1
while [ $index -le $MENU_ENTRY_NB ]; 
do
	echo -n ${index}": "
	grep -m${index} ^menuentry /etc/grub2-efi.cfg | cut -d \' -f2 | tail -n1
	index=$(($index+1))
done

echo "select an entry"
read choice


NEW_DEFAULT=$(grep -m${choice} ^menuentry /etc/grub2-efi.cfg | cut -d \' -f2 | tail -n1)
debug "entry chosen:" $NEW_DEFAULT

grub2-set-default "$NEW_DEFAULT"
grub2-mkconfig -o /etc/grub2-efi.cfg

