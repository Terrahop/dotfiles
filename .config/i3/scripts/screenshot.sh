# Screenshots

notify-send -t 1000 -u normal -a "Screenshot" "Select area or window to capture"
sleep 1.5

DATE=$(date +%F)
mkdir -p $HOME/Media/Screenshots/$DATE

scrot -s -f -c -b -q 30 -e 'xclip -selection c -t image/png < $f' \
  "$HOME/Media/Screenshots/$DATE/area-$(date +%H:%M:%S).png"

if [ "$?" == "0" ];
  then
    notify-send -t 3000 -u normal -a "Screenshot" "Successfully Saved!"
  else
    notify-send -t 3000 -u normal -a "Screenshot" "Something went wrong with the capture"
fi

