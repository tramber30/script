#!/bin/bash

C0="Quit"
C1="conservative"
C2="ondemand"
C3="userspace"
C4="powersave"
C5="performance"

pushd /sys/devices/system/cpu >/dev/null
for x in cpu[0-9]*
do
	echo "${x}: $(cat $x/cpufreq/scaling_governor)"
done

if [ $(id -u) -ne 0 ]; then
	popd > /dev/null
	exit 0
fi

if [ ! -z $1 ]; then
        VALUE=$1
else
	echo "choose one:"
	echo "0- Quit"
	echo "1- $C1"
	echo "2- $C2"
	echo "3- $C3"
	echo "4- $C4"
	echo "5- $C5"
	read -p "enter your choice:" VALUE
fi

case $VALUE in
0*)
	RES=$C0
	exit
	;;
1*)
        RES=$C1
        ;;
2*)
        RES=$C2
        ;;
3*)
        RES=$C3
        ;;
4*)
        RES=$C4
        ;;
5*)
        RES=$C5
        ;;
*)
	exit 0
esac

echo "mode chosen: $RES"
for x in cpu[0-9]*
do
        echo $RES > $x/cpufreq/scaling_governor
done

popd > /dev/null
