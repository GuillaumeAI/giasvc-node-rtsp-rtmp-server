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

#rtmpdump -v -r $RTMPURL -y $STREAM -o $OUTDIR/1.flv -B 1
rm $OUTDIR/1.flv  &> /dev/null
rtmpdump --stop 2 \
    -v \
    -r $RTMPURL  \
    -o $OUTDIR/1.flv &> /dev/null &
rpid=$! 
echo -n "." ; sleep 1 ; echo -n "."; sleep 1 ; echo -n "."; sleep 1 ; echo -n "."
sleep 8
echo "------------------------------------------------------"
kill -9 $rpid &> /dev/null \
&& echo "GOT KILLED " \
 && \
echo "------------------------------------------------------" && \
\
cframe="$OUTDIR/$TIME.jpg"; echo "cframe: $cframe" &&\
(ffmpeg -i $OUTDIR/1.flv \
    -ss 00:00:02 -an \
    -r 1 -vframes 1 \
    -s 1280x860 \
    -y "$cframe" &> /dev/null && \
   ( cp $cframe $OUTDIR/_current.jpg || echo "Error with Copying Frame :((")  &> /dev/null && \
    echo -n "--------FFMPEG OK ..." && \
     sleep 6 \
    || echo -n "----FFMPEG NOT OK ---") \
|| (echo "Can kill anyone" &&  kill -9 $rpid  &> /dev/null)



echo "Waiting until next run..."; echo -n "." ; sleep 1 ; echo -n "."
#sleep 4

$0 &


exit;