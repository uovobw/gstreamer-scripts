#!/bin/bash

VIDEO_DATA_PORT=5000
VIDEO_CTRL_PORT=5001
AUDIO_DATA_PORT=5002
AUDIO_CTRL_PORT=5003
VIDEO_RETC_PORT=5004
AUDIO_RETC_PORT=5005
IP=${1}

gst-launch-1.0 -v rtpbin name=rtpbin latency=80\
 v4l2src ! video/x-raw,format=\(string\)YUY2,width=\(int\)320,height=\(int\)240,framerate=\(fraction\)30/1 !\
 videoconvert ! videoscale  ! avenc_mpeg4 max-key-interval=1 max-bframes=2 ! rtpmp4vpay config-interval=2 ! rtpbin.send_rtp_sink_0\
 rtpbin.send_rtp_src_0 ! udpsink host=${IP} port=${VIDEO_DATA_PORT} sync=false async=false\
 rtpbin.send_rtcp_src_0 ! udpsink host=${IP} port=${VIDEO_CTRL_PORT} sync=false async=false\
 udpsrc port=${VIDEO_RETC_PORT} ! rtpbin.recv_rtcp_sink_0\
 alsasrc device=\"hw:0,0\" ! audio/x-raw,format=\(string\)S16LE ! audiorate ! audioresample ! volume volume=4.0 ! lamemp3enc bitrate=128 target=0 quality=5 encoding-engine-quality=1 mono=true ! rtpmpapay ! rtpbin.send_rtp_sink_1\
 rtpbin.send_rtp_src_1 ! udpsink host=${IP} port=${AUDIO_DATA_PORT} sync=false async=false\
 rtpbin.send_rtcp_src_1 ! udpsink host=${IP} port=${AUDIO_CTRL_PORT} sync=false async=false\
 udpsrc port=${AUDIO_RETC_PORT} ! rtpbin.recv_rtcp_sink_1
