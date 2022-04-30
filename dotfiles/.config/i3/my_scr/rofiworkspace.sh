#!/bin/bash

function gen_workspaces()
{
    	# needs jq installed (sudo apt install jq)
	i3-msg -t get_workspaces | jq -r '.[].name'
}

WORKSPACE=$( gen_workspaces | rofi -dmenu -p "Workspace:")

if [ -n "${WORKSPACE}" ]
then
    i3-msg workspace "${WORKSPACE}"
fi
