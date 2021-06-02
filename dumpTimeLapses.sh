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
# CodeRemixed by Guillaume Descoteaux-Isabelle, 2021 to @STCGoal create a framework for remixing my own traditional art with AI 
##

if [ -e $binroot/__fn.sh ] && [ "$FNLOADED" == "" ]; then
   source $binroot/__fn.sh $@
fi
LOG_FILE=/var/log/gia/ffmpeg_montage.txt; LOG_ENABLED=y
DEBUG=1

STREAM='STREAM ID HERE'
RTMPURL='rtmp://localhost/live/ueo'
OUTDIR=$(pwd)'/caps'
OF=$OUTDIR/1.flv
TIME=$(date +"%Y%m%d_%H%M%S")

mkdir -p $OUTDIR

#rtmpdump -v -r $RTMPURL -y $STREAM -o $OF -B 1
rm $OF  &> /dev/null
rtmpdump --stop 2 \
    -v \
    -r $RTMPURL  \
    -o $OF &> /dev/null &
rpid=$! 
echo -n "." ; sleep 1 ; echo -n "."; sleep 1 ; echo -n "."; sleep 1 ; echo -n "."
sleep 15
echo "------------------------------------------------------"
kill -9 $rpid &> /dev/null \
&& echo "GOT KILLED " \
 && \
echo "------------------------------------------------------" && \
\
(cframe="$OUTDIR/$TIME.jpg"; echo "cframe: $cframe") &&\
(ffmpeg -i $OF \
    -ss 00:00:02 -an \
    -r 1 -vframes 1 \
    -s 1280x860 \
    -y "$cframe" &> /dev/null && \
   (cp _current.jpg $OUTDIR/_previous.jpg ; cp $cframe $OUTDIR/_current.jpg || echo "Error with Copying Frame :((")  &> /dev/null && \
    echo -n "--------FFMPEG OK ..." && \
    (cd caps ; . _diff.sh) && \
     (sleep 3;if [ -e $OF ]; then rm $OF  &> /dev/null ;fi ) \
    || echo -n "----FFMPEG NOT OK ---") \
|| (echo "Can kill anyone" ;  kill -9 $rpid  &> /dev/null ; rm $OF  &> /dev/null)



echo "Waiting until next run..." #; echo -n "." ; sleep 1 ; echo -n "."
#sleep 4

$0 &


exit;