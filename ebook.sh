#!/bin/bash

(
	echo '<meta charset="utf-8">'
	echo '<style>body { font-size: 30px; }</style>'
	for file in *.acsm
	do
		echo "<p><a href='$file'>"
		echo $(grep dc:creator "$file" | cut -d\> -f2 | cut -d\< -f1) - $(grep dc:title "$file" | cut -d\> -f2 | cut -d\< -f1)
		echo "</a></p>"
	done
) > index.html

python3 -m http.server

rm index.html
