#!/bin/bash

DST=$1

gst-launch-1.0 -v rtpbin name=rtpbin \
    v4l2src ! video/x-raw,width=320,height=240,framerate=10/1 ! autovideoconvert ! \
    x264enc pass=qual quantizer=20 tune=zerolatency ! rtph264pay ! rtpbin.send_rtp_sink_0 \
    rtpbin.send_rtp_src_0 ! udpsink host=$DST port=5000 sync=false async=false \
    rtpbin.send_rtcp_src_0 ! udpsink host=$DST port=5001 sync=false async=false    \
    udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
    alsasrc do-timestamp=true ! audio/x-raw,rate=24000 ! speexenc vbr=true quality=10 ! rtpspeexpay ! rtpbin.send_rtp_sink_1                   \
    rtpbin.send_rtp_src_1 ! udpsink host=$DST port=5002 sync=false async=false \
    rtpbin.send_rtcp_src_1 ! udpsink host=$DST port=5003 sync=false async=false    \
    udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1
