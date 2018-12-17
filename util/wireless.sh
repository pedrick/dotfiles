#!/bin/sh

DEVICE=`ip link | grep "state UP" | awk '{print $2}' | rev | cut -c "2-" | rev`

iwconfig $DEVICE 2>&1 | grep -q no\ wireless\ extensions\. && {
    echo wired
    exit 0
}

essid=`iwconfig ${DEVICE} | awk -F '"' '/ESSID/ {print $2}'`
strength=`iwconfig ${DEVICE} | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1`

if [ -z "${essid}" ]
then
    echo Disconnected
else
    echo $essid $strength
fi

exit 0
