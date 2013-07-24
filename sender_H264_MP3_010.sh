#!/bin/bash

DST=$1

gst-launch-0.10 -v gstrtpbin name=rtpbin \
    v4l2src ! video/x-raw-yuv,width=\(int\)320,height=\(int\)240,framerate=\(fraction\)30/1 ! ffmpegcolorspace ! \
    x264enc pass=qual quantizer=20 tune=zerolatency ! rtph264pay ! rtpbin.send_rtp_sink_0 \
    rtpbin.send_rtp_src_0 ! udpsink host=$DST port=5000 sync=false async=false   \
    rtpbin.send_rtcp_src_0 ! udpsink host=$DST port=5001 sync=false async=false    \
    udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
    alsasrc device="default" ! audio/x-raw-int ! audiorate ! audioresample ! \
    lamemp3enc bitrate=128 target=0 quality=5 encoding-engine-quality=1 mono=true ! rtpmpapay ! rtpbin.send_rtp_sink_1                   \
    rtpbin.send_rtp_src_1 ! udpsink host=$DST port=5002 sync=false async=false  \
    rtpbin.send_rtcp_src_1 ! udpsink host=$DST port=5003 sync=false async=false    \
    udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1
