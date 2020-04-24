#!/usr/bin/env bash

## My Modified version of https://github.com/HackeSta/polybar-kdeconnect ##

# CONFIGURATION
LOCATION=0
YOFFSET=-380
XOFFSET=-630
WIDTH=12
WIDTH_WIDE=24
THEME=$HOME/.config/rofi/theme_kde_connect.rasi

# Color Settings of Icon shown in Polybar
COLOR_DISCONNECTED='#1e6e21'       # Device Disconnected
COLOR_NEWDEVICE='#1e5d20'          # New Device
COLOR_CONNECTED='#1e5d20'         # Connected

SEPERATOR='|'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

show_devices() {
  IFS=$','
  devices=""
  for device in $(qdbus --literal org.kde.kdeconnect /modules/kdeconnect org.kde.kdeconnect.daemon.devices); do
    device_id=$(echo "$device" | awk -F'["|"]' '{print $2}')
    device_name=$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$device_id org.kde.kdeconnect.device.name)
    is_reachable="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$device_id org.kde.kdeconnect.device.isReachable)"
    is_trusted="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$device_id org.kde.kdeconnect.device.isTrusted)"
    if [ "$is_reachable" = "true" ] && [ "$is_trusted" = "true" ]
    then
      device_battery="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$device_id org.kde.kdeconnect.device.battery.charge)"
      is_charging="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/f3ffd22f7e03bb92 org.kde.kdeconnect.device.battery.isCharging)"
      icon_display=$(get_icon $device_battery $is_charging)
      devices+="%{A1:. $DIR/polybar-kdeconnect.sh; show_menu $device_name $device_id $device_battery:}$icon_display $device_battery%%{A} $SEPERATOR"
    elif [ "$is_reachable" = "false" ] && [ "$is_trusted" = "true" ]
    then
      devices+="$(get_icon -1)$SEPERATOR"
    else
      can_request_pair="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$device_id org.kde.kdeconnect.device.hasPairingRequests)"
      if [ "$can_request_pair" = "true" ]
      then
        show_pmenu2 $device_name $device_id
      fi
      icon_display=$(get_icon -2)
      devices+="%{A1:. $DIR/polybar-kdeconnect.sh; show_pmenu $device_name $device_id $:}$icon_display%{A}$SEPERATOR"
    fi
  done
  echo "${devices::-1}"
}

show_menu () {
  menu="$(rofi -sep "|" -dmenu -i -p "$1" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH -hide-scrollbar -padding 1px -lines 5 -no-config <<< "Find Device|Send File|Browse Device|Unpair")"
  case "$menu" in
    *Ping) qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/ping org.kde.kdeconnect.device.ping.sendPing ;;
    *'Find Device') qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/findmyphone org.kde.kdeconnect.device.findmyphone.ring ;;
    *'Send File') qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/share org.kde.kdeconnect.device.share.shareUrl "file://$(zenity --file-selection)" ;;
    *'Unpair' )
      zenity --question --title="Unpair Device?" --text="Are you sure you want to unpair \"$1\" ?" --width=250 --height 100
      if [ "$?" == "0" ]; then
        qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2 org.kde.kdeconnect.device.unpair
      fi
    ;;
    *'Browse Device')
      mounted=$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/f3ffd22f7e03bb92/sftp org.kde.kdeconnect.device.sftp.isMounted)
      if [ "$mounted" == "false" ]; then
        qdbus org.kde.kdeconnect /modules/kdeconnect/devices/f3ffd22f7e03bb92/sftp org.kde.kdeconnect.device.sftp.mount
        sleep 1
        mounted=$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/f3ffd22f7e03bb92/sftp org.kde.kdeconnect.device.sftp.isMounted)
      fi
      if [ "$mounted" == "true" ]; then
        exec urxvt -e ranger /run/user/1000/$2/storage/emulated/0/
      fi
    ;;
  esac
}

show_pmenu () {
  menu="$(rofi -sep "|" -dmenu -i -p "$1" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH -hide-scrollbar -line-padding 1 -padding 20 -lines 1 <<< "Pair Device")"
  case "$menu" in
    *'Pair Device') qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2 org.kde.kdeconnect.device.requestPair
  esac
}

show_pmenu2 () {
  menu="$(rofi -sep "|" -dmenu -i -p "$1 has sent a pairing request" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH_WIDE -hide-scrollbar -line-padding 4 -padding 20 -lines 2 <<< "Accept|Reject")"
  case "$menu" in
    *'Accept') qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2 org.kde.kdeconnect.device.acceptPairing ;;
    *) qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2 org.kde.kdeconnect.device.rejectPairing
  esac
}
get_icon () {
  icon=''

  case $1 in
    "-1")
    ICON="%{F$COLOR_DISCONNECTED}"$icon"%{F-}"
    ;;
    "-2")
    ICON="%{F$COLOR_NEWDEVICE}"$icon"%{F-}"
    ;;
    *)
    ICON="%{F$COLOR_CONNECTED}"$icon"%{F-}"
    ;;
  esac
  echo $ICON
}

case $1 in
  "show")
    show_devices
  ;;
esac
