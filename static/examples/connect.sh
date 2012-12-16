#!/bin/sh

# This script queries the etherpad server for the latest version of the pad
# and loads it into chuck.  It makes the pad self-inluding, so that when the
# time expires in chuck, the script begins again.

# This script will run chuck the first time the script compiles cleanly.
# You can also run chuck manually by either loading an already downloaded
# pad.ck, or in --server --loop mode, in which case --add is used to chuck the
# script to the server.  This lets you use dev builds of chuck outside of your
# $PATH.

# OPTIONS
# HOST: etherpad host, defaults to localhost:9001

HOST=${HOST:-http://localhost:9001}

echo "Starting chucK server"
(chuck --server --loop)&
sleep 1

echo "Reading etherpads"
while true; do
	pad_list=`egrep '^{"key":"pad:.*-chuck-pad",' var/dirty.db | awk -F',' '{print $1}' | uniq | sed -e 's/^{"key":"pad://' -e 's/"$//'`

	for pad in ${pad_list}; do
		wget -q ${HOST}/p/${pad}/export/txt -O ${pad}.ck

		# see if new pad compiles properly
		COMPILE_ERRORS=`chuck --silent current_pad.ck 2>&1 |
							grep "\[${pad}.ck\]:line("`

		if [ -z "${COMPILE_ERRORS}" ]; then
			echo "Machine.add(\"running_${pad}.ck\");" >> ${pad}.ck
			should_run=""
			if [ ! -f "running_${pad}.ck" ] ; then
				echo "NO FILE == SHOULD RUN"
				should_run="yes"
			fi
			mv ${pad}.ck running_${pad}.ck
			if [ ! -z "${should_run}" ] ; then
				echo "ADDING: ${should_run}"
				chuck + running_${pad}.ck
			fi
		else
			echo "COMPILE_ERRORS=${COMPILE_ERRORS}"
		fi
	done
	sleep 1
done
