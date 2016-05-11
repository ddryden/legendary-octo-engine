#!/bin/sh
# You will need the libav-tools package installed for avconv or ffmpeg
# installed to use the other option.

if ! hash avconv 2>/dev/null; then
    echo >&2 "You need to install libav-tools or ffmpeg"
    echo >&2 "              apt-get install libav-tools"
    exit 1
fi
 
INFO=$(xwininfo -frame)
  
WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' |\
        grep -oEe '[0-9]+x[0-9]+')
WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' |\
        grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/+/,/' )
  
#ffmpeg -f x11grab -y -r 15 -s $WIN_GEO -i :0.0+$WIN_XY -vcodec ffv1 -threads 2 $1.avi
 
avconv -f x11grab -y -r 30 -s $WIN_GEO -i :0.0+$WIN_XY -vcodec libvpx -vf scale="-1:720" -cpu-used 3 -threads 4 -an $1.webm

