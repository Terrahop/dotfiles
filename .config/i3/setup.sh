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

# Setup env
export MONITOR_EDP=$(xrandr --query | egrep -E "eDP.*\sconnected" | awk '{print $1}')
export MONITOR_HDMI=$(xrandr --query | egrep -E "HDMI.*\sconnected" | awk '{print $1}')
export MONITOR_DP=$(xrandr --query | egrep -w -m 1 -E "DP.*\sconnected" | awk '{print $1}')

# For logging
export DEBUG=1
log() {
  if [ "$DEBUG" == "1" ]; then
    echo -e "$1"
  fi
}
export -f log

# Get resolution of external monitors to set mode
export HDMI_RES=$(xrandr --query | egrep -E "HDMI.*\sconnected" | awk '{print $3}')
export DP_RES=$(xrandr --query | egrep -E "DP.*\sconnected" | awk '{print $3}')

# If the external HDMI monitor has been set to primary, output of HDMI_RES will be
# "primary" so fix that.
[ $HDMI_RES == "primary" ] && export HDMI_RES=$(xrandr --query | egrep -E "HDMI.*\sconnected" | awk '{print $4}')

# If the external DP monitor has been set to primary, output of DP_RES will be
# "primary" so fix that.
[ $DP_RES == "primary" ] && export DP_RES=$(xrandr --query | egrep -E "HDMI.*\sconnected" | awk '{print $4}')

# If hdmi doesnt exist set hdmi xrdb value to laptop display
if [ -z "$MONITOR_HDMI" ]; then
  sed -i --follow-symlinks '/! hdmi name/!b;n;c*.hdmi:  '${MONITOR_EDP}'' $HOME/.Xresources
else
  sed -i --follow-symlinks '/! hdmi name/!b;n;c*.hdmi:  '${MONITOR_HDMI}'' $HOME/.Xresources
fi

# If dp doesnt exist set dp xrdb value to laptop display
if [ -z "$MONITOR_DP" ]; then
  sed -i --follow-symlinks '/! dp name/!b;n;c*.dp:  '${MONITOR_EDP}'' $HOME/.Xresources
else
  sed -i --follow-symlinks '/! dp name/!b;n;c*.dp:  '${MONITOR_DP}'' $HOME/.Xresources
fi

# Also do the same for laptop display as it's alias can change
sed -i --follow-symlinks '/! edp name/!b;n;c*.edp:  '${MONITOR_EDP}'' $HOME/.Xresources

# Run xrandr based on monitor setup
if [ -z "$MONITOR_HDMI" ] && [ -z "$MONITOR_DP" ]; then
  log 'HDMI: Not Detected \nDP: Not Detected'
  ~/.config/i3/screen_layouts/single_monitor.sh
fi

if [ ! -z "$MONITOR_HDMI" ] && [ -z "$MONITOR_DP" ]; then
  log "HDMI: Detected \nDP: Not Detected \nHDMI resolution is $HDMI_RES"

  # Second argument defines if hdmi is on left(1) or right(0)
  ~/.config/i3/screen_layouts/double_monitor_hdmi.sh $HDMI_RES 1
fi

if [ -z "$MONITOR_HDMI" ] && [ ! -z "$MONITOR_DP" ]; then
  log "HDMI: Not Detected \nDP: Detected \nDP resolution is $DP_RES"

  # Second argument defines if DP is on left(1) or right(0)
  ~/.config/i3/screen_layouts/double_monitor_dp.sh $DP_RES 0
fi

if [ ! -z "$MONITOR_HDMI" ] && [ ! -z "$MONITOR_DP" ]; then
  log "HDMI: Detected \nDP: Detected \nHDMI resolution is $HDMI_RES \nDP resolution is $DP_RES"

  # Same as before, hdmi first, dp second
  ~/.config/i3/screen_layouts/triple_monitor.sh $HDMI_RES $DP_RES 1 0
fi

xrdb $HOME/.Xresources
