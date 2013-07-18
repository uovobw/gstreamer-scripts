#!/bin/bash

DST=192.168.18.217

gst-launch-1.0 $@ rtpbin name=rtpbin v4l2src ! videoconvert !\
    vp8enc ! rtpvp8pay ! rtpbin.send_rtp_sink_0 \
                               rtpbin.send_rtp_src_0 ! udpsink host=$DST port=5000 \
                               rtpbin.send_rtcp_src_0 ! udpsink host=$DST port=5001 sync=false async=false \
                               udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0 \
    audiotestsrc ! speexenc ! rtpspeexpay ! rtpbin.send_rtp_sink_1 \
    rtpbin.send_rtp_src_1 ! udpsink host=$DST port=5002 \
    rtpbin.send_rtcp_src_1 ! udpsink host=$DST port=5003 sync=false async=false \
    udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1

