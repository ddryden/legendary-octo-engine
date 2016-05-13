#!/bin/sh
# You will need the libav-tools package installed for avconv or ffmpeg
# installed to use the other option.

FPS="25"
#Codecs and containers that work well: Lower quality = (libvpx and webm), High Quality = (ffv1 and avi)
VCODEC="ffv1"
CONTAINER="avi"
CPU_OPS="-threads 2"

outputfile="X11WindowRecording.$CONTAINER"
if [ "$1x" != "x" ]; then
	 outputfile="$1.$CONTAINER"
fi

recording_tool=0
if hash avconv 2>/dev/null; then
        recording_tool="avconv"
elif hash ffmpeg 2>/dev/null; then
        recording_tool="ffmpeg"
else
    echo >&2 "You need to install libav-tools or ffmpeg"
    echo >&2 "If your on Debian/Ubuntu try:"
    echo >&2 "              apt-get install libav-tools"
    echo >&2 ""
    exit 1
fi
 
INFO=$(xwininfo -frame)
  
WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' |\
        grep -oEe '[0-9]+x[0-9]+')
WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' |\
        grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/+/,/' )

$recording_tool -f x11grab -y -r $FPS -s $WIN_GEO -i $DISPLAY+$WIN_XY -vcodec $VCODEC -vf scale="-1:720" $CPU_OPS -an $outputfile
 
