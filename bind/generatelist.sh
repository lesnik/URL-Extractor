#!/bin/bash
# Yeri Tiete
#	aka Tuinslak
# http://yeri.be

FILE=example.log
TMPFILE=/tmp/_urlextractor
OUTPUT=list.txt

# delete old file if existing
[ -e $OUTPUT ] && rm $OUTPUT

# get 6th column,		tolower()		get unique   remove '<', '>', '=', '#'	remove arpa requests	remove random namebench queries		remove more namebench crap
awk '{print $6 }' $FILE | awk '{print tolower($0)}' | awk '!x[$0]++' | sed '/[=#<>]/d' | awk '{print tolower($0)}' | grep -Ev 'in-addr.arpa' | grep -Ev 'namebench' | egrep -Ev '[a-z0-9]{26}' | sort > $TMPFILE

while read a; do {
	[[ `wget $a --timeout=30 --tries=1 --user-agent="URL-Extractor (http://yeri.be/ij)" --no-check-certificate -O /dev/null 2>&1 | grep "200 OK"` != "" ]] && echo $a >> $OUTPUT
} done < $TMPFILE
