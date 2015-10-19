#!/bin/bash -i

# Define CUSTOM_PROFILE in order to open terminals with the related profile
#CUSTOM_PROFILE="FIRST"
CUSTOM_PROFILE=""


if [ -z $CUSTOM_PROFILE ]; then
	/usr/bin/gnome-terminal --title=FIRST --working-directory=$PWD --geometry=104x55+0+0 
	/usr/bin/gnome-terminal --title=SECOND --working-directory=$PWD --geometry=105x28+960+0
	/usr/bin/gnome-terminal --title=THIRD --working-directory=$PWD --geometry=105x23+960+595
else
	/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=FIRST --working-directory=$PWD --geometry=104x55+0+0
	/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=SECOND --working-directory=$PWD --geometry=105x28+960+0
	/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=THIRD --working-directory=$PWD --geometry=105x23+960+595
fi
