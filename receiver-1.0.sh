#!/bin/bash

gst-launch-1.0 -v rtpbin name=rtpbin \
    udpsrc caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)MPEG4" \
    port=5000 ! rtpbin.recv_rtp_sink_0 \
    rtpbin. ! rtpmp4vdepay ! avdec_mpeg4 ! xvimagesink \
    udpsrc port=5001 ! rtpbin.recv_rtcp_sink_0  \
    rtpbin.send_rtcp_src_0 ! udpsink port=5005 sync=false async=false \
    udpsrc caps="application/x-rtp,media=(string)audio,clock-rate=(int)8000,encoding-name=(string)SPEEX,encoding-params=(string)1,octet-align=(string)1" \
    port=5002 ! rtpbin.recv_rtp_sink_1  \
    rtpbin. ! rtpspeexdepay ! speexdec ! alsasink \
    udpsrc port=5003 ! rtpbin.recv_rtcp_sink_1 \
    rtpbin.send_rtcp_src_1 ! udpsink port=5007 sync=false async=false
