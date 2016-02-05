#!/bin/bash
GS_PROXY_PATH="org.gnome.system.proxy"
GS_PROXY_MODE_KEY="mode"
MODE_tab=("none" "manual" "auto")

# Example of ignored hosts
#/usr/bin/gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', 'intel.com', '.intel.com', '192.168.0.0/24']"

get_mode_num()
{
	if [ -z $1 ]; then
		echo "get_mode_num: no argument"
	fi
	str=$(echo $1 | sed "s/'//g")

	case $str in
	"none")
		echo "0"
		;;
	"manual")
		echo "1"
		;;
	"auto")
		echo "2"
		;;
	*)
		echo "get_mode_num: wrong argument"
		;;
	esac
}

PROXY_MODE=$(/usr/bin/gsettings get $GS_PROXY_PATH $GS_PROXY_MODE_KEY)
if [ -z $PROXY_MODE ]; then
	echo "error retrieveing current mode"
else
	echo -ne "current mode: $PROXY_MODE \nswitch?"
	read choice
	m=$(get_mode_num $PROXY_MODE)
	if [ $m -ne 0 ]; then
		/usr/bin/gsettings set $GS_PROXY_PATH $GS_PROXY_MODE_KEY "none"
		if [ $? -eq 0 ]; then
			echo "new  mode 'none'"
		else
			echo "gesttings set failed"
		fi
	else
		/usr/bin/gsettings set $GS_PROXY_PATH $GS_PROXY_MODE_KEY "auto"
		if [ $? -eq 0 ]; then
			echo "new  mode 'auto'"
		else
			echo "gesttings set failed"
		fi
	fi
fi


	

