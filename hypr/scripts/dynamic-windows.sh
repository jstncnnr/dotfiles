#!/bin/bash

function handle() {
  if [[ ${1:0:10} == "openwindow" ]]; 
  then

    window_id=$(get_window_id $1)
    workspace_id=$(get_workspace_id $1)

    if [[ $workspace_id == "special" ]] then
      workspace_id=-98
    fi

    window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .windows")
    if [[ $window_count -eq 1 ]]
    then
      add_reserved  
    elif [[ $window_count -eq 2 ]]
    then
      del_reserved
      hyprctl dispatch layoutmsg togglesplit
    fi
    
  elif [[ ${1:0:11} == "closewindow" ]];
  then

    workspace_id=$(hyprctl activewindow -j | jq ".workspace.id")
    window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .windows")

    if [[ $window_count -eq 1 ]];
    then
      add_reserved
    else
      del_reserved
    fi

  elif [[ ${1:0:10} == "movewindow" ]];
  then

    window_id=$(get_window_id $1)
    workspace_id=$(get_workspace_id $1)

    if [[ $workspace_id == "special" ]]
    then
      workspace_id=-98
    fi

    window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .windows")
    if [[ $window_count -eq 1 ]];
    then
      add_reserved
    else
      del_reserved
    fi

  elif [[ ${1:0:18} == "changefloatingmode" ]];
  then

    workspace_id=$(hyprctl activewindow -j | jq ".workspace.id")
    window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .windows")

    if [[ $window_count -eq 1 ]]
    then
      window_id=$(hyprctl activewindow -j | jq -r ".address")
      status=$(hyprctl activewindow -j | jq ".floating")

      if [[ $status == "false" ]]
      then
        add_reserved
      else
        del_reserved
      fi
    fi

  elif [[ ${1:0:9} == "workspace" ]];
  then

    workspace_id=$(hyprctl activeworkspace -j | jq ".id")
    if [[ $workspace_id == "special" ]]
    then
      del_reserved
      return
    fi

    window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .windows")

    if [[ $window_count -eq 1 ]]
    then
      add_reserved
    else
      del_reserved
    fi

  elif [[ ${1:0:13} == "activespecial" ]];
  then

    workspace_id=$(echo $1 | cut --delimiter ">" --fields=3 | cut --delimiter "," --fields=1)
    if [[ $workspace_id == "special:magic" ]]
    then
      del_reserved
    else
      window_count=$(hyprctl activeworkspace -j | jq ".windows")
      if [[ $window_count -eq 1 ]]
      then
        add_reserved
      else
        del_reserved
      fi
    fi

  fi
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
