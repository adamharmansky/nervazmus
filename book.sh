#!/bin/sh

get_title() {
	if [ -d "$1" ]; then
		if [ -e "$1/index.md" ]; then
			get_title "$1/index.md"
		fi
	else 
		head "$1" | sed -n '/^# /{s/^# //; p}'
	fi
}


generate_document() {
	echo "Parsing file $1" >&2
	
	(
		echo "<!DOCTYPE html>"
		echo "<html>"
			echo "<head>"
				echo "<title>"
					get_title "$1"
				echo "</title>"
				echo '<meta name="viewport" content="width=device-width, initial-scale=1">'
				echo '<meta charset="UTF-8">'
				echo "<link rel=stylesheet href=/style.css>"
			echo "</head>"
			echo "<body>"
				cat navbar.html
				echo "<main>"
					pandoc -f markdown -t html < "$1"
				echo "</main>"
			echo "</body>"
		echo "</html>"
	) > $(echo "$1" | sed 's/\.md$/.html/')
}

parse_item() {
	if [ -d "$1" ]; then
		ls -v "$1" | while read entry; do
			parse_item "$1/$entry"
		done
	else
		if [ -n "$(echo "$1" | awk '/\.md$/')" ]; then
			generate_document "$1"
		fi
	fi
}

echo "Generating website..." >&2

parse_item .

# vi: noet
