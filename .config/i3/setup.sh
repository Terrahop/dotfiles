## Screen setup ##

# In order to set the monitor xrdb values the following needs to be somewhere
# in ~/.Xresources
#
# ! hdmi name
# *.hdmi:
#
# ! edp name
# *.edp:
#
# ! dp name
# *.dp:

# For logging
export DEBUG=0
log() {
  if [ "$DEBUG" == "1" ]; then
    echo -e "$1"
  fi
}
export -f log

# Get monitor aliases
export MONITOR_EDP=$(xrandr --query | egrep -E "eDP.*\sconnected" | awk '{print $1}')
export MONITOR_HDMI=$(xrandr --query | egrep -E "HDMI.*\sconnected" | awk '{print $1}')
export MONITOR_DP=$(xrandr --query | egrep -w -m 1 -E "DP.*\sconnected" | awk '{print $1}')

# Get resolution of external connected monitors
export HDMI_RES=$(xrandr --query | egrep -A1 -E "HDMI.*\sconnected" | awk '{print $1}' | tail -n +2)
export DP_RES=$(xrandr --query | egrep -A1 -E "DP.*\sconnected" | awk '{print $1}' | tail -n +2)

# If hdmi doesnt exist set hdmi xrdb value to laptop alias
if [ -z "$MONITOR_HDMI" ]; then
  sed -i --follow-symlinks '/! hdmi name/!b;n;c*.hdmi: '${MONITOR_EDP}'' $HOME/.Xresources
else
  sed -i --follow-symlinks '/! hdmi name/!b;n;c*.hdmi: '${MONITOR_HDMI}'' $HOME/.Xresources
fi

# If dp doesnt exist set dp xrdb value to laptop alias
if [ -z "$MONITOR_DP" ]; then
  sed -i --follow-symlinks '/! dp name/!b;n;c*.dp: '${MONITOR_EDP}'' $HOME/.Xresources
else
  sed -i --follow-symlinks '/! dp name/!b;n;c*.dp: '${MONITOR_DP}'' $HOME/.Xresources
fi

# Also do the same for laptop display as it's alias can change
sed -i --follow-symlinks '/! edp name/!b;n;c*.edp: '${MONITOR_EDP}'' $HOME/.Xresources

## Run xrandr based on monitor setup ##

# Only laptop display
if [ -z "$MONITOR_HDMI" ] && [ -z "$MONITOR_DP" ]; then
  log 'HDMI: Not Detected \nDP: Not Detected'
  ~/.config/i3/screen_layouts/single_monitor.sh
fi

# Laptop + HDMI monitor
if [ ! -z "$MONITOR_HDMI" ] && [ -z "$MONITOR_DP" ]; then
  log "HDMI: Detected \nDP: Not Detected \nHDMI resolution is $HDMI_RES"

  # Second argument defines if hdmi is on left(1) or right(0) of laptop display
  ~/.config/i3/screen_layouts/double_monitor_hdmi.sh $HDMI_RES 1
fi

# Laptop + DP monitor
if [ -z "$MONITOR_HDMI" ] && [ ! -z "$MONITOR_DP" ]; then
  log "HDMI: Not Detected \nDP: Detected \nDP resolution is $DP_RES"

  # Second argument defines if DP is on left(1) or right(0) of laptop display
  ~/.config/i3/screen_layouts/double_monitor_dp.sh $DP_RES 0
fi

# Laptop + HDMI + DP monitors
if [ ! -z "$MONITOR_HDMI" ] && [ ! -z "$MONITOR_DP" ]; then
  log "HDMI: Detected \nDP: Detected \nHDMI resolution is $HDMI_RES \nDP resolution is $DP_RES"

  # Too complex to handle like before, positions should be be manually
  # specified in script
  ~/.config/i3/screen_layouts/triple_monitor.sh $HDMI_RES $DP_RES
fi

# Finally set the xrdb values
xrdb $HOME/.Xresources

