#!/bin/bash

function handle() {
  if [[ ${1:0:10} == "openwindow" ]]; 
  then

    window_id=$(get_window_id $1)
    workspace_id=$(get_workspace_id $1)

    if [[ $workspace_id == "special" ]] then
      workspace_id=-98
    fi

    window_count=$(get_window_count $workspace_id)
    if [[ $window_count -gt 1 ]]
    then
      del_reserved
      hyprctl dispatch layoutmsg togglesplit
    else
      add_reserved
    fi
    
  elif [[ ${1:0:11} == "closewindow" ]];
  then

    workspace_id=$(hyprctl activewindow -j | jq ".workspace.id")
    window_count=$(get_window_count $workspace_id)-1

    if [[ $window_count -gt 1 ]];
    then
      del_reserved
    else
      add_reserved
    fi

  elif [[ ${1:0:10} == "movewindow" ]];
  then

    window_id=$(get_window_id $1)
    workspace_id=$(get_workspace_id $1)

    if [[ $workspace_id == "special" ]]
    then
      workspace_id=-98
    fi

    window_count=$(get_window_count $workspace_id)
    if [[ $window_count -gt 1 ]];
    then
      del_reserved
    else
      add_reserved
    fi

  elif [[ ${1:0:18} == "changefloatingmode" ]];
  then

    workspace_id=$(hyprctl activewindow -j | jq ".workspace.id")
    window_count=$(get_window_count $workspace_id)

    if [[ $window_count -gt 1 ]];
    then
      del_reserved
    else
      add_reserved
    fi

  elif [[ ${1:0:9} == "workspace" ]];
  then

    workspace_id=$(hyprctl activeworkspace -j | jq ".id")
    if [[ $workspace_id == "special" ]]
    then
      del_reserved
      return
    fi

    window_count=$(get_window_count $workspace_id)

    if [[ $window_count -gt 1 ]]
    then
      del_reserved
    else
      add_reserved
    fi

  elif [[ ${1:0:13} == "activespecial" ]];
  then

    workspace_id=$(echo $1 | cut --delimiter ">" --fields=3 | cut --delimiter "," --fields=1)
    if [[ $workspace_id == "special:magic" ]]
    then
      del_reserved
    else
      window_count=$(get_window_count $workspace_id)
      if [[ $window_count -gt 1 ]]
      then
        del_reserved
      else
        add_reserved
      fi
    fi

  fi
}

function get_window_count() {
  hyprctl clients -j | jq "[.[] | select(.workspace.id == $1) | select(.floating == false)] | length"
}

function add_reserved() {
  hyprctl keyword monitor DP-1,addreserved,0,0,865,865
}

function del_reserved() {
  hyprctl keyword monitor DP-1,addreserved,0,0,0,0
}

function get_workspace_id() {
  echo $1 | cut --delimiter ">" --fields=3 | cut --delimiter "," --fields=2
}

function get_window_id() {
  echo $1 | cut --delimiter ">" --fields=3 | cut --delimiter "," --fields=1
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done
