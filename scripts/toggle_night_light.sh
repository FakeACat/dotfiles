#!/bin/bash

if [[ $(pgrep gammastep) = "" ]]
then
	gammastep -O 3000
else
	pkill gammastep
fi
