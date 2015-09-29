#!/bin/bash

CUSTOM_PROFILE="FIRST"

/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=FIRST --working-directory=$PWD --geometry=104x55+0+0
/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=SECOND --working-directory=$PWD --geometry=105x28+960+0
/usr/bin/gnome-terminal --profile=$CUSTOM_PROFILE --title=THIRD --working-directory=$PWD --geometry=105x23+960+595
