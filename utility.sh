#!/bin/bash

# debug: trace if DEBUG_ON variable is defined
#
function debug()
{
        if [ $DEBUG_LEVEL -gt 0 ]
        then
                echo $@
        fi
}

# debug_var: deeper debug trace
#
function debug_var()
{
        if [ $DEBUG_LEVEL -gt 1 ]
        then
                echo $@
        fi
}

# error: error trace
#
function error()
{
        echo -e "${RED}##ERROR: $@ ${NC}"
}

# fatal_error: error print function + exit
#
function fatal_error()
{
        error $@
        exit
}

# check_var: check non null variable list
#
function check_var()
{
        debug "in check_var()"
        for i in $@
        do
                debug_var "variable name: <$i>, value <${!i}>"
                if [ -z ${!i} ]
                then
                        fatal_error "undefined value <$i>"
                fi
        done
        debug "out check_var()"
}
