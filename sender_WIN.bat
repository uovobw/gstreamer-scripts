set PATH=%PATH%;C:\QDesk\Bin\VirtualWaiterFrontDesk

set DST=192.168.18.21

gst-launch-0.10.exe -v gstrtpbin name=rtpbin ^
    dshowvideosrc ! video/x-raw-yuv,width=(int)320,height=(int)240,framerate=(fraction)30/1 ! ffmpegcolorspace ! ^
    x264enc pass=qual quantizer=20 tune=zerolatency ! rtph264pay ! rtpbin.send_rtp_sink_0 ^
    rtpbin.send_rtp_src_0 ! udpsink host=%DST% port=5000                            ^
    rtpbin.send_rtcp_src_0 ! udpsink host=%DST% port=5001 sync=false async=false    ^
    udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           ^
    directsoundsrc ! audio/x-raw-int ! audiorate ! audioresample ! ^
    speexenc vbr=true quality=10 ! rtpspeexpay ! rtpbin.send_rtp_sink_1                   ^
    rtpbin.send_rtp_src_1 ! udpsink host=%DST% port=5002                            ^
    rtpbin.send_rtcp_src_1 ! udpsink host=%DST% port=5003 sync=false async=false    ^
    udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1
