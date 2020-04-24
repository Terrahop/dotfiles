########## Audio Downloader ##########
#
# Requires: youtube-dl, jq, rofi(optional), parallel
#
# Youtube DL Batch Audio Downloader
# Either provide a url as an argument or let it get set here through rofi.

### Vars ###

# Directory to download audio to
DOWNLOAD_DIR=$HOME/Downloads/music_downloads
mkdir -p $DOWNLOAD_DIR

export PARALLEL_HOME=$HOME/.config/parallel
mkdir -p $PARALLEL_HOME

# Check if a url was passed to script
if [ -z "$1" ]; then
  URL=$( rofi -theme ~/.config/rofi/scripts/scripts-theme.rasi -no-config -threads 0 -lines 10 -width 50 -location 0 -dmenu -i -p "Url:" )
else
  URL="$1"
fi

### Functions ###

# Download single video and extract audio
download_single () {
  youtube-dl -x --no-playlist --ignore-errors \
    -f 'bestaudio[ext=flac]/bestaudio[ext=webm]/bestaudio' \
    --audio-quality 0 -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
    --add-metadata --metadata-from-title "(?P<artist>.+?) - (?P<title>.+)" \
    $URL
  notify-send -t 10000 -u normal -a "Youtube DL" "Downloaded all media"
}

# Download each video in the playlist in seperate instances of youtube-dl.
download_playlist () {
  while read line; do
    sem -j +0 "
      youtube-dl -x --no-playlist --ignore-errors \
        -f 'bestaudio[ext=flac]/bestaudio[ext=webm]/bestaudio' --audio-quality 0 \
        -o '$DOWNLOAD_DIR/%(title)s.%(ext)s' \
        --add-metadata --metadata-from-title '(?P<artist>.+?) - (?P<title>.+)' \
        $line
  "
  done < /tmp/$1
  sem --wait
  notify-send -t 10000 -u normal -a "Youtube DL" "Downloaded all media"
  #rm /tmp/$1
}

### Finalize ###

# If the link is a youtube video in a playlist, album in bandcamp etc, generate
# a file containing a list of the urls for each source and download each one in
# a seperate instance of youtube-dl.
case $URL in
  *youtu*list*)
    tmp_file=$(date +%F_%T-urls.txt)
    youtube-dl -j --flat-playlist "$URL" | jq -r '"https://youtu.be/"+ .url' > /tmp/$tmp_file
    download_playlist $tmp_file
    ;;
  *bandcamp*album*)
    tmp_file=$(date +%F_%T-urls.txt)
    youtube-dl -j --flat-playlist "$URL" | jq -r '.url' > /tmp/$tmp_file
    download_playlist $tmp_file
    ;;
  *soundcloud*sets*)
    echo "Soundcloud"
    tmp_file=$(date +%F_%T-urls.txt)
    youtube-dl -j --flat-playlist "$URL" | jq -r '.url' > /tmp/$tmp_file
    download_playlist $tmp_file
    ;;
  *)
    download_single
esac

