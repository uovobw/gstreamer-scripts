set PATH=%PATH%;C:\QDesk\Bin\VirtualWaiterFrontDesk

set DST=192.168.17.45
set SRC=192.168.18.211

gst-launch-0.10.exe -v ^
        gstrtpbin name=rtpbin                                          ^
        udpsrc caps="application/x-rtp,media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264" ^
        port=5000 ! rtpbin.recv_rtp_sink_0                                ^
        rtpbin. ! rtph264depay ! ffdec_h264 ! dshowvideosink sync=false async=false  ^
        udpsrc port=5001 ! rtpbin.recv_rtcp_sink_0  ^
        rtpbin.send_rtcp_src_0 ! udpsink host=%DST% port=5005 sync=false async=false        ^
        udpsrc caps="application/x-rtp,media=(string)audio, clock-rate=(int)16000, encoding-name=(string)SPEEX, encoding-params=(string)1, payload=(int)110" ^
        port=5002 ! rtpbin.recv_rtp_sink_1                                ^
        rtpbin. ! rtpspeexdepay ! speexdec ! audioresample ! audioconvert ! directsoundsink sync=false async=false ^
        udpsrc port=5003 ! rtpbin.recv_rtcp_sink_1                               ^
        rtpbin.send_rtcp_src_1 ! udpsink host=%DST% port=5007 sync=false async=false

