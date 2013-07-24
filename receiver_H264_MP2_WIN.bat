set PATH=%PATH%;C:\QDesk\Bin\VirtualWaiterFrontDesk

set DST=192.168.219.102

gst-launch-0.10.exe -v ^
        gstrtpbin name=rtpbin                                          ^
        udpsrc caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264" ^
        port=5000 ! rtpbin.recv_rtp_sink_0                                ^
        rtpbin. ! rtph264depay ! h264parse ! ffdec_h264  ! autovideosink sync=true async=true   ^
        udpsrc port=5001 ! rtpbin.recv_rtcp_sink_0  ^
        rtpbin.send_rtcp_src_0 ! udpsink host=%DST% port=5005 sync=false async=false^
        udpsrc caps="application/x-rtp,media=(string)audio, clock-rate=(int)90000, encoding-name=(string)MPA, encoding-params=(string)1" ^
        port=5002 ! rtpbin.recv_rtp_sink_1                                ^
        rtpbin. ! rtpmpadepay ! ffdec_mp2float ! audioresample ! audioconvert ! directsoundsink sync=true async=true^
        udpsrc port=5003 ! rtpbin.recv_rtcp_sink_1                               ^
        rtpbin.send_rtcp_src_1 ! udpsink host=%DST% port=5007 sync=false async=false

