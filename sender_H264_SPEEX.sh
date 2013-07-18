#!/bin/bash

DST=192.168.18.217

gst-launch-1.0 -v rtpbin name=rtpbin \
    v4l2src ! video/x-raw,width=320,height=240,framerate=10/1 ! autovideoconvert ! \
    x264enc pass=cbr quantizer=20 bitrate=256 tune=zerolatency ! rtph264pay ! rtpbin.send_rtp_sink_0 \
    rtpbin.send_rtp_src_0 ! udpsink host=$DST port=5000                            \
    rtpbin.send_rtcp_src_0 ! udpsink host=$DST port=5001 sync=false async=false    \
    udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
    alsasrc ! audio/x-raw,rate=8000 ! speexenc bitrate=8000 ! rtpspeexpay ! rtpbin.send_rtp_sink_1                   \
    rtpbin.send_rtp_src_1 ! udpsink host=$DST port=5002                            \
    rtpbin.send_rtcp_src_1 ! udpsink host=$DST port=5003 sync=false async=false    \
    udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1
