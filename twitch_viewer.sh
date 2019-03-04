#!/bin/bash

TWITCH_HOST="www.twitch.tv"
TWITCH_URL="https://"$TWITCH_HOST
BROWSER_PATH="/usr/bin/chromium-browser"
STREAM_NAME=
export DISPLAY=:0
RED_COLOR="\033[31m"
RESET_COLOR="\033[0m"

VERBOSE=0
TIME_TO_LIVE=0

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
                tw_error "chromium path doesn't exist" 1
        fi
        if ! ping -c1 $TWITCH_HOST > /dev/null
        then
                tw_debug "unable to join server, retry..."
                if ! ping -c3 $TWITCH_HOST 
                then
                        tw_error "unable to join host" 4
                fi
        fi
}

function usage()
{
        echo -ne "Usage: twitch_viewer [OPTIONS]\n
        Try 'twitch_viewer --help' for more information."
}

function tw_help()
{
        echo "Usage: twitch_viewer [OPTIONS]
        Launch a browser wen on a specific stream
        Options:
        -h              this help
        -s STREAM       launch a specific stream
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
                tw_error "index mismatch" 3
        fi
        index=1
        for i in $STREAM_LIST
        do
                if [ $index -eq $input ]
                then
                        tw_debug "chosen stream: "$i
                        STREAM_NAME=$i
                fi
                index=$(($index+1))
        done
}

function tw_autokill()
{
        tw_debug "autokill function"
        

}

function tw_play()
{
        tw_check
        if [ -z $STREAM_NAME ]
        then
                tw_default_menu
        fi

	STREAM_URL=${TWITCH_URL}"/"$STREAM_NAME

        tw_debug "stream name: "$STREAM_URL
        $BROWSER_PATH $STREAM_URL &

        if [ $TIME_TO_LIVE -gt 0 ]
        then
                tw_autokill
        fi
}



OPTIND=1

while getopts "hvs:" opt
do
        case "$opt" in
                h)
                        tw_help
                        exit 0
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
