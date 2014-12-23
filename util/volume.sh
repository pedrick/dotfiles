#! /bin/bash

function get_running_sink()
{
    echo `pactl list short sinks | grep 'RUNNING' | awk '{print $1}'`
}

function get_volume()
{
    # ID of sink should be passed as a parameter
    local vols_lines=`pactl list sinks | grep 'Sink\|State\|Volume' | sed -e 'N;N;N;s/\n/ /g'`
    echo `echo "$vols_lines" | grep "#$1 " | awk '{print $7}'`
}

function set_volume()
{
    # Takes parameters sink# and amount
    echo "Setting volume on $1 to $2"
    pactl set-sink-volume $1 -- "$2"
}

case "$1" in
    get)
        get_volume $(get_running_sink)
        ;;
    up)
        set_volume $(get_running_sink) "+2%"
        ;;
    down)
        set_volume $(get_running_sink) "-2%"
        ;;
    mute)
        pactl set-sink-mute $(get_running_sink) toggle
        ;;
    running)
        get_running_sink
        ;;
    *)
        echo 'Usage: `basename 0` {get, up, down, mute, running}'
        ;;
esac
exit 0
