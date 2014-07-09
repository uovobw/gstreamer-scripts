#!/bin/bash

VIDEO_DATA_PORT=5000
VIDEO_CTRL_PORT=5001
AUDIO_DATA_PORT=5002
AUDIO_CTRL_PORT=5003
VIDEO_RETC_PORT=5004
AUDIO_RETC_PORT=5005
IP=${1}

gst-launch-1.0 -v rtpbin name=bin latency=80\
    udpsrc port=${VIDEO_DATA_PORT} ! application/x-rtp,media=\(string\)video,clock-rate=\(int\)90000,encoding-name=\(string\)MP4V-ES,encoding-params=\(string\)1 ! bin.recv_rtp_sink_0 \
    udpsrc port=${VIDEO_CTRL_PORT} ! bin.recv_rtcp_sink_0 \
    bin.send_rtcp_src_0 ! udpsink host=${IP} port=${VIDEO_RETC_PORT} sync=false async=false \
    udpsrc port=${AUDIO_DATA_PORT} ! application/x-rtp,media=\(string\)audio,clock-rate=\(int\)90000,encoding-name=\(string\)MPA ! bin.recv_rtp_sink_1 \
    udpsrc port=${AUDIO_CTRL_PORT} ! bin.recv_rtcp_sink_1 \
    bin.send_rtcp_src_1 ! udpsink host=${IP} port=${AUDIO_RETC_PORT} sync=false async=false \
    bin. ! rtpmpadepay  ! mpegaudioparse ! mad ! audioconvert ! audioresample ! alsasink sync=true async=true \
    bin. ! rtpmp4vdepay ! avdec_mpeg4 ! videoconvert ! xvimagesink sync=false async=false

