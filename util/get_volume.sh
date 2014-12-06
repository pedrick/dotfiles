#! /bin/bash
echo `pactl list sinks | grep 'Sink\\|Volume' | awk '{if( NR==2 ) print \$3}'`
exit 0
