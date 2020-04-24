#!/bin/bash

##### Vars #####

# Set firefox profile ID here
PROFILE_ID=""

# Try set profile ID automatically if not provided
# WARNING: This may or may not be set to the correct profile automatically
if [ "$PROFILE_ID" == "" ]; then
  PROFILE_DIR="$(ls -d $HOME/.mozilla/firefox/*.default*)"
else
  PROFILE_DIR="$HOME/.mozilla/firefox/$PROFILE_ID"
fi

# Autoconf locations
AUTOCONF_CFG="/usr/lib/firefox/autoconfig.cfg"
AUTOCONF_JS="/usr/lib/firefox/defaults/pref/autoconfig.js"

# Start page location
STARTPAGE_DIR="$PROFILE_DIR/chrome/homeFork"

##### Hacky way to get newtab page working with local files #####
# Requires root permissions

function setup_ffx_cfg () {

  echo -e "\nSetting up firefox autoconf files\n"

  # Check if both autconf files exist, if they do, exit.
  if [[ ! -f "$AUTOCONF_CFG" && ! -f "$AUTOCONF_JS" ]]; then

    # Create autoconf cfg file
    sudo tee -a $AUTOCONF_CFG > /dev/null <<EOT
    // ...
    var {classes:Cc,interfaces:Ci,utils:Cu} = Components;
    var newTabURL = "$STARTPAGE_DIR/index.html";
    aboutNewTabService = Cc["@mozilla.org/browser/aboutnewtab-service;1"].getService(Ci.nsIAboutNewTabService);
    aboutNewTabService.newTabURL = newTabURL;
EOT

    # Copy autconf js file
    sudo cp ./autoconfig.js $AUTOCONF_JS

    echo -e "Finished setting up autoconf! Created files at:\n$AUTOCONF_JS\n$AUTOCONF_CFG"

  else
    echo "Autoconf files already exist, please back them up and/or delete them before running"
    exit 1
  fi

}


##### Setup chrome css #####

function setup_userChrome() {

  CHROME_DIR="$PROFILE_DIR/chrome"

  echo -e "\nSetting up userChrome css theme and start page\n"

  mkdir -p $CHROME_DIR

  if [[ $(ls -A $CHROME_DIR 2>/dev/null) ]]; then
    echo -e "Chrome folder already contains files\nBacking up existing files and replacing..."

    NOW=`date '+%Y_%m_%d-%H:%M:%S'`
    BACKUP_FILE="$PROFILE_DIR/chrome-$NOW"

    mkdir $BACKUP_FILE
    mv $CHROME_DIR/* $BACKUP_FILE/
    echo -e "Done! Backup is at $BACKUP_FILE\n"
  fi

  echo -e "Getting theme\n"
  git clone https://github.com/EliverLara/firefox-sweet-theme.git $CHROME_DIR/firefox-sweet-theme

  echo -e "\nGetting start page\n"
  git clone https://github.com/Teiem/homeFork.git $CHROME_DIR/homeFork

  # Create single-line user CSS files if non-existent or empty.
  [[ -s userChrome.css ]] || echo >> $CHROME_DIR/userChrome.css

  # Import this theme at the beginning of the CSS files.
  sed -i '1s/^/@import "firefox-sweet-theme\/userChrome.css";\n/' $CHROME_DIR/userChrome.css

  echo -e "\nFinished setting up theme and start page!"

}


##### Create service for running http server for the newtab page #####

function setup_service() {

  SERVICE_FILE="/lib/systemd/system/firefox-newtabpage.service"

  echo -e "\nSetting up newtab service\n"

  if [ ! -f "$SERVICE_FILE" ]; then
    sudo touch $SERVICE_FILE

    sed "10s;ExecStart=;ExecStart=/usr/bin/env python -m http.server --directory $STARTPAGE_DIR 33137;" \
      ./firefox-newtabpage.service \
      | sudo tee -a $SERVICE_FILE >/dev/null

    sudo systemctl start firefox-newtabpage.service
    sudo systemctl enable firefox-newtabpage.service

    echo -e "\nService setup and enabled at $SERVICE_FILE"
  else
    echo -e "Service file already exists at $SERVICE_FILE"
  fi

}

case $1 in
  "all")
    setup_ffx_cfg
    setup_userChrome
    setup_service
    ;;
  "service")
    setup_service
    ;;
  "cfg")
    setup_ffx_cfg
    ;;
  "chrome")
    setup_userChrome
    ;;
  *)
    echo -e "Please specify type of install (all,service,cfg,chrome)
    \nExample: ./setup all"
    ;;
esac

