#!/bin/sh
ffmpeg -i frame%05d.png $1
#avconv -r 30 -i frame.%05d.png -r 30 -b 65536k $1

