#!/bin/bash

DST=$1

gst-launch-0.10 -v\
        gstrtpbin name=rtpbin                                          \
        udpsrc caps="application/x-rtp,media=(string)video, clock-rate=(int)90000, encoding-name=(string)MP4V-ES" \
        port=5000 ! rtpbin.recv_rtp_sink_0                                \
        rtpbin. ! rtpmp4vdepay ! ffdec_mpeg4 max-threads=1 ! xvimagesink sync=true async=true  \
        udpsrc port=5001 ! rtpbin.recv_rtcp_sink_0  \
        rtpbin.send_rtcp_src_0 ! udpsink port=5005 sync=false async=false        \
        udpsrc caps="application/x-rtp,media=(string)audio, clock-rate=(int)90000, encoding-name=(string)MPA, encoding-params=(string)1" \
        port=5002 ! rtpbin.recv_rtp_sink_1                                \
        rtpbin. ! rtpmpadepay ! mad ! audioresample ! audioconvert ! alsasink sync=true async=true \
        udpsrc port=5003 ! rtpbin.recv_rtcp_sink_1                               \
        rtpbin.send_rtcp_src_1 ! udpsink host=$DST port=5007 sync=false async=false

