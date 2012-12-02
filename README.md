# COLLABESTRA - online collaborative score and synthesizer editing

## INTRO

Collabestra is a collaborative source editing tool for livecoding
preformances.  It is based on
[Etherpad Lite](https://github.com/Pita/etherpad-lite).

All performers should conenct to the server via a web browser and collaborate
on the source code.  The source is automatially passed into a running instance
of [ChucK](http://chuck.cs.princeton.edu/).

The audio uses [jack](http://jackaudio.org/) to pipe out over icecast/darkice.

## SETUP

The sound-generating machine (server) should run collabestra.  Performers only
need to have a modern web browser.

1. `qjackctl`: Run jackd at 44.1kHz
2. `bin/run.sh`: Start the etherpad server
3. `static/examples/connect.sh`: repeatedly read the etherpad into ChucK
4. `cd static/examples && darkice -c darkice.cfg`: run audio server

## COMPOSING
1. connect to http://localhost:9001 (or whatever the server is called)
2. jam

# License
[Apache License v2](http://www.apache.org/licenses/LICENSE-2.0.html)
