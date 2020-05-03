#!/bin/bash

# Audio Downloader
#
# Youtube DL Batch Audio Downloader.
# Either provide a url as an argument to this script, or let it get set here
# through rofi.
#
# Requirements
# Download: youtube-dl, parallel
# Parser: jq
# GUI: rofi(optional)

#########################
# Vars
#########################

# Directory to download audio to
DOWNLOAD_DIR=$HOME/Downloads/music_downloads

# Set parallel temp directory
PARALLEL_HOME=$HOME/.config/parallel

# Theme for rofi is being used
ROFI_THEME=$HOME/.config/rofi/themes/flat-purple.rasi

# Check if a url was passed to script
if [ -z "$1" ]; then
  URL=$( rofi -theme $ROFI_THEME -no-config \
  -threads 0 -lines 10 -width 50 -location 0 \
  -dmenu -i -p "Url:" )
else
  URL="$1"
fi


#########################
# functions
#########################

# Helper: Test if a command exists
check() {
  command -v $1 > /dev/null 2>&1 ||
    { exit_error 1 "'$2' not found, Please install it."; exit 1;  }
}

# Setup
setup() {
  mkdir -p $DOWNLOAD_DIR
  mkdir -p $PARALLEL_HOME

  check youtube-dl
  check jq
  check parallel
  [ -z "$ROFI_THEME" ] || check rofi
}

# Download single video and extract audio
download_single () {
  youtube-dl -x --no-playlist --ignore-errors \
    -f 'bestaudio[ext=flac]/bestaudio[ext=webm]/bestaudio' \
    --audio-quality 0 -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
    --add-metadata --metadata-from-title "(?P<artist>.+?) - (?P<title>.+)" \
    $URL
  [ -z "$URL" ] || notify-send -t 10000 -u normal -a "Youtube DL" "Downloaded all media"
  exit 0
}

# Download each video in the playlist in seperate instances of youtube-dl using
# parallel.
# $1: Space seperated string of urls
download_playlist () {
  for item in $1; do
    notify-send "line: $item"
    sem -j +0 "
      youtube-dl -x --no-playlist --ignore-errors \
        -f 'bestaudio[ext=flac]/bestaudio[ext=webm]/bestaudio' --audio-quality 0 \
        -o '$DOWNLOAD_DIR/%(title)s.%(ext)s' \
        --add-metadata --metadata-from-title '(?P<artist>.+?) - (?P<title>.+)' \
        $item
  "
  done
  sem --wait

  [ -z "$URL" ] || notify-send -t 10000 -u normal -a "Youtube DL" "Downloaded all media"
  exit 0
}

#########################
# Finalize
#########################

# Do initial checks
setup

# If the link is a youtube video in a playlist, album in bandcamp etc, generate
# a file containing a list of the urls for each source and download each one in
# a seperate instance of youtube-dl.
case $URL in
  *youtu*list*)
    tmp_file=$(date +%F_%T-urls.txt)
    URLS=$(youtube-dl -j --flat-playlist "$URL" | jq -r '"https://youtu.be/"+ .url')
    notify-send "urls: $URLS"
    download_playlist "$URLS"
    ;;
  *bandcamp*album*)
    tmp_file=$(date +%F_%T-urls.txt)
    URLS=$(youtube-dl -j --flat-playlist "$URL" | jq -r '.url')
    download_playlist $URLS
    ;;
  *soundcloud*sets*)
    echo "Soundcloud"
    tmp_file=$(date +%F_%T-urls.txt)
    URLS=$(youtube-dl -j --flat-playlist "$URL" | jq -r '.url')
    download_playlist $URLS
    ;;
  *)
    download_single
esac

