duk(){ 
	export D=$(du -b diff.png | tr "K" " " | awk '// {print $1}' | sed -e 's/,//g')
}

duk
a=$D;echo $a

compare _previous.jpg _current.jpg  -compose src diff.png 
duk
b=$D; echo $b
ISDIFF=$(expr $a - $b)
if [ "$ISDIFF" != 0 ]; then #@state changed image is new
		echo "---------CHANGED DETECTED in new Image---$a - $b = $ISDIFF----------"
		echo "-- SOME ACTION LIKE Inferencing()"
		echo "------------------------------------"
		echo "$(date) :: Got diff $a - $b = $ISDIFF-" >> log.txt
else 
			echo "--------NO CHANGED DETECTED in new Image---$a - $b = $ISDIFF--------"
fi
