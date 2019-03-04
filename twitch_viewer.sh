#!/bin/bash

TWITCH_HOST="www.twitch.tv"
TWITCH_URL="https://"$TWITCH_HOST
BROWSER_NAME="chromium-browser"
BROWSER_PATH="/usr/bin/"$BROWSER_NAME
STREAM_NAME=
export DISPLAY=:0
RED_COLOR="\033[31m"
RESET_COLOR="\033[0m"

VERBOSE=0
RELAUNCH=0
TIME_TO_LIVE=0
KILL_ONLY=0

STREAM_NAME=
STREAM_LIST="thedivisiongame overwatchleague playoverwatch"

function tw_error()
{
        MESSAGE=$1
        if [ ! -z $2 ] && [ $2 -gt 0 ]
        then
                EXIT_CODE=$2
        else
                EXIT_CODE=1
        fi
        echo -e $RED_COLOR"ERROR: "${1}${RESET_COLOR}
        exit $EXIT_CODE
}

function tw_debug()
{
        [ $VERBOSE -eq 1 ] && echo $@
}

function tw_check()
{
        if [ ! -x $BROWSER_PATH ]
        then
                tw_error "tw_check: chromium path doesn't exist" 1
        fi
        if ! ping -c1 $TWITCH_HOST > /dev/null
        then
                tw_debug "tw_check: unable to join server, retry..."
                if ! ping -c3 $TWITCH_HOST 
                then
                        tw_error "tw_check: unable to join host" 4
                fi
        fi
}

function usage()
{
        echo -ne "Usage: twitch_viewer [OPTIONS]
        Try 'twitch_viewer -h' for more information.\n"
}

function tw_help()
{
        echo "Usage: twitch_viewer [OPTIONS]
        Launch a web browser on a specific stream
        Options:
        -k              kill previous instances
        -h              this help
        -r              relaunch, kill previous instance before starting stream
        -s STREAM       launch a specified stream
        -t HOURS        launch stream for HOURS hours then kill it
        -v              enable verbose"
}

function tw_default_menu()
{
        index=1
        echo "select your stream"
        for i in $STREAM_LIST
        do
              echo  $index"- "$i
              index=$(($index+1))
        done

        read input
        if [ $input -ge $index ] || [ $input -le 0 ]
        then
                tw_error "[tw_default_menu] index mismatch" 3
        fi
        index=1
        for i in $STREAM_LIST
        do
                if [ $index -eq $input ]
                then
                        tw_debug "[tw_default_menu] chosen stream: "$i
                        STREAM_NAME=$i
                fi
                index=$(($index+1))
        done
}

function tw_autokill()
{
        if [ $(ps aux | grep $BROWSER_NAME | grep -c "twitch") -gt 0 ]
        then
                for pid in $(ps aux | grep $BROWSER_NAME | grep "twitch" | tr -s ' ' | cut -d " " -f2)
                do
                        tw_debug "[tw_autokill] kill $pid"
                        kill $pid 
                done
        else
                tw_debug "[tw_autokill] no process found"
        fi
}

function tw_play()
{
        if [ $KILL_ONLY -eq 1 ]
        then
                tw_autokill
                exit 0
        fi

        tw_check
        if [ -z $STREAM_NAME ]
        then
                tw_default_menu
        fi

	STREAM_URL=${TWITCH_URL}"/"$STREAM_NAME

        if [ $RELAUNCH -eq 1 ]
        then
                tw_autokill
        fi

        if [ $TIME_TO_LIVE -gt 0 ]
        then
                tw_debug "[tw_play] stream url: "$STREAM_URL ", timeout: " $TIME_TO_LIVE
                timeout ${TIME_TO_LIVE}h $BROWSER_PATH $STREAM_URL &
        else
                tw_debug "[tw_play] stream url: "$STREAM_URL
                $BROWSER_PATH $STREAM_URL &
        fi
}

OPTIND=1
while getopts "hkrs:t:v" opt
do
        case "$opt" in
                k)
                        KILL_ONLY=1
                        ;;
                h)
                        tw_help
                        exit 0
                        ;;
                r)
                        RELAUNCH=1
                        ;;
                s)
                        STREAM_NAME=$OPTARG
                        ;;
                t)
                        TIME_TO_LIVE=$OPTARG
                        ;;
                v)
                        VERBOSE=1
                        ;;
                ?)
                        usage
                        exit 0
                        ;;
        esac
done
shift $((OPTIND-1))
tw_play
