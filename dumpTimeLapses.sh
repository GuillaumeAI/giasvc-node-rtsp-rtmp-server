#!/bin/bash

##
#  RTMP to JPEG timelapse script
#  github.com/kythin
#
#  Simple script to take an RTMP streaming url and save a jpeg every 10 seconds.
#
#  Requires 'ffmpeg' and 'rtmpdump'
#      apt-get install ffmpeg rtmpdump
#  
##


STREAM='STREAM ID HERE'
RTMPURL='rtmp://localhost/live/ueo'
OUTDIR=$(pwd)'/caps'

TIME=$(date +"%Y%m%d_%H%M%S")

mkdir -p $OUTDIR

rtmpdump -v -r $RTMPURL -y $STREAM -o $OUTDIR/1.flv -B 1
ffmpeg -i $OUTDIR/1.flv -ss 00:00:01 -an -r 1 -vframes 1 -s 800x600 -y $OUTDIR/$TIME.jpg


echo "Waiting until next run..."
sleep 10

./cap.sh


exit;