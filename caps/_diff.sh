duk(){ 
	export A=$(du -ksh diff.png | tr "K" " " | awk '// {print $1}' | sed -e 's/,//g')
}

duk
a=$A;echo $a

compare _previous.jpg _current.jpg  -compose src diff.png 
duk
b=$A
echo "$(expr $a - $b)" 
sleep 2
feh diff.png
