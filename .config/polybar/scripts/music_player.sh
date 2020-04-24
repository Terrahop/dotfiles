#!/bin/sh

# Stored in .Xresources, read into polybar through xrdb, dumped into here
# Modes: s=spotify, c=cmus
mode=$(polybar --dump=player_mode right)

# Get spotify's sink id for controlling audio volume through pactl
spotify_sink_id() {
  app_name="Spotify"
  current_sink_num=''
  sink_num_check=''
  app_name_check=''
  pactl list sink-inputs |while read line; do \
    sink_num_check=$(echo "$line" |sed -rn 's/^Sink Input #(.*)/\1/p')
    if [ "$sink_num_check" != "" ]; then
      current_sink_num="$sink_num_check"
    else
      app_name_check=$(echo "$line" \
      |sed -rn 's/application.name = "([^"]*)"/\1/p')
      if [ "$app_name_check" = "$app_name" ]; then
        echo "$current_sink_num"
      fi
    fi
  done
}

sink_id="$(spotify_sink_id)"

next_song() {
  if [ "$mode" == "s" ]; then
    playerctl next
  fi
  if [ "$mode" == "c" ]; then
    cmus-remote -n
  fi
}

prev_song() {
  if [ "$mode" == "s" ]; then
    playerctl previous
  fi
  if [ "$mode" == "c" ]; then
    cmus-remote -r
  fi
}

play_pause() {
  if [ "$mode" == "s" ]; then
    playerctl play-pause
  fi
  if [ "$mode" == "c" ]; then
    cmus-remote -u
  fi
}

volume_up() {
  if [ "$mode" == "s" ]; then
    pactl set-sink-input-volume $sink_id +5%
  fi
  if [ "$mode" == "c" ]; then
    cmus-remote -v +5%
  fi
}

volume_down() {
  if [ "$mode" == "s" ]; then
    pactl set-sink-input-volume $sink_id -5%
  fi
  if [ "$mode" == "c" ]; then
    cmus-remote -v -5%
  fi
}

toggle_mode() {
  case $mode in
    "s")
      sed -i --follow-symlinks '/! Polybar music player mode/!b;n;c*.mode:  c' $HOME/.Xresources
      xrdb $HOME/.Xresources
    ;;
    "c")
      sed -i --follow-symlinks '/! Polybar music player mode/!b;n;c*.mode:  s' $HOME/.Xresources
      xrdb $HOME/.Xresources
    ;;
  esac
}

display() {
  if [ "$mode" == "s" ]; then
    if [ "$(playerctl status)" == "Playing" ] || [ "$(playerctl status)" == "Paused" ]; then
      output="%{F#3cb703}$(playerctl status)"
      echo "$output"
    else
      echo "%{F#3cb703}No Music :("
    fi
  fi
  if [ "$mode" == "c" ]; then
    case $(cmus-remote -Q | grep -m1 "" | awk '{print $2}') in
      "playing")
        output="%{F#e30e70}Playing"
      ;;
      "paused")
        output="%{F#e30e70}Paused"
      ;;
      *)
        output="%{F#e30e70}No Music :("
      ;;
    esac
    echo "$output"
  fi
}
case "$1" in
  --next)
    next_song
  ;;
  --prev)
    prev_song
  ;;
  --play)
    play_pause
  ;;
  --toggle)
    toggle_mode
  ;;
  --vol_up)
    volume_up
  ;;
  --vol_down)
    volume_down
  ;;
  *)
    display
  ;;
esac

