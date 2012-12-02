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
# CHUCK_TO_SERVER: add to an existing chuck runtime
# DONT_CHUCK: a chuck script referencing pad.ck is already in the chuck runtime
# HOST: etherpad host, defaults to localhost:9001

HOST=${HOST:-http://localhost:9001}

while true
do
	wget -q ${HOST}/p/collexistra-chuck-pad/export/txt -O current_pad.ck

	# see if new pad compiles properly
	COMPILE_ERRORS=`chuck --silent current_pad.ck 2>&1 | grep "\[current_pad.ck\]:line("`

	if [ -z "${COMPILE_ERRORS}" ]
	then
		echo "Machine.add(\"pad.ck\");" >> current_pad.ck
		cp current_pad.ck pad.ck
		if [ -z $DONT_CHUCK ] ; then
			echo "Starting Chuck"
			DONT_CHUCK=1
			ADD=""
			if [ ! -z $CHUCK_TO_SERVER ] ; then
				echo "... to server"
				ADD="+"
			fi
			chuck ${ADD} pad.ck
		fi
	else
		echo "COMPILE_ERRORS=${COMPILE_ERRORS}"
	fi
	sleep 1
done

