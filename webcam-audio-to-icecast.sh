#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 <ip> <port> <mountpoint>"
    exit 1
fi

stty -echo
printf "Password:"
read ICECAST_PASSWORD
stty echo
printf "\n"

gst-launch-1.0 v4l2src do-timestamp=true ! video/x-raw,width=\(int\)320,height=\(int\)240,framerate=\(fraction\)10/1 ! queue leaky=1 !\
    theoraenc bitrate=400 quality=32 ! queue leaky=1 ! oggmux name=mux \
    alsasrc ! queue leaky=1 ! audioconvert ! vorbisenc quality=0.1 ! mux. \
    mux. ! queue leaky=1 ! shout2send ip=${1} port=${2} mount=/${3} password=${ICECAST_PASSWORD} sync=true async=true
