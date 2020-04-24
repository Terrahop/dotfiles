#!/bin/bash
# Rofi extension for BitWarden-cli
# Requires: keyutils
#
# Original by mattydebie: https://github.com/mattydebie/bitwarden-rofi

# Temporary session token
SESSION_TOKEN=

# Options
CLEAR=7 # Clear password from clipboard after N seconds (0 to disable)
AUTO_LOCK=900 # Automatically purge the session token after N seconds

# Holds the available items in memory
ITEMS=

# Which command will be used to emulate keyboard auto typing
# Options:
# 'sudo ydotool' (wayland)
# 'xdotool
AUTOTYPE_MODE=xdotool

# Which clipboard program to use
# Options:
# 'xclip'
# 'xsel'
# 'wl-clipboard' (wayland)
CLIPBOARD_MODE=xclip

# Specify what happens when pressing Enter on an item.
# Options:
# 'copy_password'
# 'auto_type all'
# 'auto_type password'
ENTER_CMD=copy_password

# Keyboard shortcuts
KB_SYNC="Alt+r"
KB_URLSEARCH="Alt+u"
KB_NAMESEARCH="Alt+n"
KB_FOLDERSELECT="Alt+c"
KB_TOTPCOPY="Alt+t"
KB_LOCK="Alt+L"
KB_TYPEALL="Alt+1"
KB_TYPEUSER="Alt+2"
KB_TYPEPASS="Alt+3"

# Item type classification
TYPE_LOGIN=1
TYPE_NOTE=2
TYPE_CARD=3
TYPE_IDENTITY=4

# Populated in parse_cli_arguments
ROFI_OPTIONS=()
DEDUP_MARK="(+)"

# Location of the theme file to use
ROFI_THEME=$HOME/.config/rofi/scripts/scripts-theme.rasi

# Location of the file where login names will be stored for the auto matching
# of logins. This is mostly for matching browser tabs, it depends on the names of
# bitwarden entries being similar to the tab name of the website you're on, it
# won't always work.
ENTRY_NAMES_DIR=/tmp/bw_names

# Source helper functions
#DIR="$(dirname "$(readlink -f "$0")")"
#source "$DIR/lib-bwmenu"

# Extract item or items matching .name, including deduplication
# $1: item name, prepended or not with deduplication mark
array_from_name() {
  item_name="$(echo "$1" | sed "s/$DEDUP_MARK //")"
  echo "$ITEMS" | jq -r ". | map(select((.name == \"$item_name\") and (.type == $TYPE_LOGIN)))"
}

# Pipe a document and deduplicate lines.
# Mark those duplicated by prepending $DEDUP_MARK
dedup_lines() {
  sort | uniq -c \
  | sed "s/^\s*1 //" \
  | sed -r "s/^\s*[0-9]+ /$DEDUP_MARK /"
}

check_active_window() {

  # Populate the entry names file if it's empty
  if [ ! -s $ENTRY_NAMES_DIR ]; then
    bw --session "$SESSION_TOKEN" list items --pretty \
      | grep "\"name\"" \
      | cut -d ":" -f 2 \
      | tr -cd 'a-zA-Z\n ' \
      | awk '{$1=$1};1' > $ENTRY_NAMES_DIR
  fi

  # Get the name of the current active window
  CURRENT_WINDOW="$(xprop -id \
    $(xprop -root 32x '\t$0' \
    _NET_ACTIVE_WINDOW | cut -f 2 \
    ) _NET_WM_NAME | cut -d "=" -f 2 \
    )"

  ENTRIES=$(cat $ENTRY_NAMES_DIR)

  shopt -s nocasematch
  while IFS= read -r entry; do
    for word in $entry; do
      if [[ "$CURRENT_WINDOW" =~ .*"$word"[^a-z] \
      && ! "$ROFI_FILTER" =~ "$word" ]]; then
        ROFI_FILTER+="$word "
      fi
    done
    [ ! -z "$ROFI_FILTER" ] && break
  done <<< "$ENTRIES"

  shopt -u nocasematch
}

ask_password() {
  mpw=$(printf '' | rofi -dmenu -p "Master Password" -password -lines 0) \
    || exit $?

  echo "$mpw" | bw unlock 2>/dev/null \
    | grep 'export' \
    | sed -E 's/.*export BW_SESSION="(.*==)"$/\1/' \
    || exit_error $? "Could not unlock vault"
}

get_session_key() {
  if [ $AUTO_LOCK -eq 0 ]; then
    keyctl purge user bw_session &>/dev/null
    SESSION_TOKEN=$(ask_password)
  else
    if ! key_id=$(keyctl request user bw_session 2>/dev/null); then
      session=$(ask_password)
      [[ -z "$session" ]] && exit_error 1 "Could not unlock vault"
      key_id=$(echo "$session" | keyctl padd user bw_session @u)
    fi

    if [ $AUTO_LOCK -gt 0 ]; then
      keyctl timeout "$key_id" $AUTO_LOCK
    fi
    SESSION_TOKEN=$(keyctl pipe "$key_id")
  fi
}

# Pre fetch all bitwarden items
load_items() {
  if ! ITEMS=$(bw list items --session "$SESSION_TOKEN" 2>/dev/null); then
    exit_error $? "Could not load items"
  fi
}

exit_error() {
  local code="$1"
  local message="$2"

  rofi -e "$message"
  exit "$code"
}

# Show the Rofi menu with options
# Reads items from stdin
rofi_menu() {

  actions=(
    -kb-custom-1 $KB_SYNC
    -kb-custom-2 $KB_NAMESEARCH
    -kb-custom-3 $KB_URLSEARCH
    -kb-custom-4 $KB_FOLDERSELECT
    -kb-custom-8 $KB_TOTPCOPY
    -kb-custom-9 $KB_LOCK
  )

  msg="<b>$KB_SYNC</b>: sync \
    | <b>$KB_URLSEARCH</b>: urls \
    | <b>$KB_NAMESEARCH</b>: names \
    | <b>$KB_FOLDERSELECT</b>: folders \
    | <b>$KB_TOTPCOPY</b>: totp \
    | <b>$KB_LOCK</b>: lock"

  [[ ! -z "$AUTOTYPE_MODE" ]] && {
    actions+=(
      -kb-custom-5 $KB_TYPEALL
      -kb-custom-6 $KB_TYPEUSER
      -kb-custom-7 $KB_TYPEPASS
    )
    msg+=" <b>$KB_TYPEALL</b>: Type all \
      | <b>$KB_TYPEUSER</b>: Type user \
      | <b>$KB_TYPEPASS</b>: Type pass"
  }

  check_active_window

  rofi -dmenu -p 'Name' \
    -theme "$ROFI_THEME" \
    -filter "$ROFI_FILTER" \
    -i -no-custom \
    -mesg "$msg" \
    "${actions[@]}" \
    "${ROFI_OPTIONS[@]}"
}

# Show items in a rofi menu by name of the item
show_items() {
  if item=$(
    echo "$ITEMS" \
    | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" \
    | dedup_lines \
    | rofi_menu
  ); then
    item_array="$(array_from_name "$item")"
    "${ENTER_CMD[@]}" "$item_array"
  else
    rofi_exit_code=$?
    item_array="$(array_from_name "$item")"
    on_rofi_exit "$rofi_exit_code" "$item_array"
  fi
}

# Show items in a rofi menu by url of the item
# if url occurs in multiple items, show the menu again with those items only
show_urls() {
  if url=$(
    echo "$ITEMS" \
    | jq -r '.[] | select(has("login")) | .login | select(has("uris")).uris | .[].uri' \
    | rofi_menu
  ); then
    item_array="$(bw list items --url "$url" --session "$SESSION_TOKEN")"
    "${ENTER_CMD[@]}" "$item_array"
  else
    rofi_exit_code="$?"
    item_array="$(bw list items --url "$url" --session "$SESSION_TOKEN")"
    on_rofi_exit "$rofi_exit_code" "$item_array"
  fi
}

show_folders() {
  folders=$(bw list folders --session "$SESSION_TOKEN")
  if folder=$(echo "$folders" | jq -r '.[] | .name' | rofi_menu); then

    folder_id=$(echo "$folders" | jq -r ".[] | select(.name == \"$folder\").id")

    ITEMS=$(bw list items --folderid "$folder_id" --session "$SESSION_TOKEN")
    show_items
  else
    rofi_exit_code="$?"
    folder_id=$(echo "$folders" | jq -r ".[] | select(.name == \"$folder\").id")
    item_array=$(bw list items --folderid "$folder_id" --session "$SESSION_TOKEN")
    on_rofi_exit "$rofi_exit_code" "$item_array"
  fi
}

# Sync local Bitwarden storage with server
sync_bitwarden() {
  bw --session "$SESSION_TOKEN" sync &>/dev/null \
    || exit_error 1 "Failed to sync bitwarden"

  # Generate a list of names of each login item and store them
  bw --session "$SESSION_TOKEN" list items --pretty \
    | grep "\"name\"" \
    | cut -d ":" -f 2 \
    | tr -cd 'a-zA-Z\n ' \
    | awk '{$1=$1};1' > $ENTRY_NAMES_DIR

  load_items
  show_items
}

# Evaluate the rofi exit codes
# $1: exit code
# $2: item array
on_rofi_exit() {
  case "$1" in
    10) sync_bitwarden;;
    11) load_items; show_items;;
    12) show_urls;;
    13) show_folders;;
    17) copy_to_clipboard "totp" "$2";;
    18) lock_vault;;
    14) auto_type all "$2";;
    15) auto_type username "$2";;
    16) auto_type password "$2";;
    *) exit "$1";;
  esac
}

# Auto type using xdotool/ydotool
# $1: what to type; all, username, password
# $2: item array
auto_type() {
  sleep 0.3
  case "$1" in
    "all")
      type_word "$(echo "$2" | jq -r '.[0].login.username')"
      type_tab
      type_word "$(echo "$2" | jq -r '.[0].login.password')"
      copy_to_clipboard "totp" "$2"
      ;;
    "username")
      type_word "$(echo "$2" | jq -r '.[0].login.username')"
      ;;
    "password")
      type_word "$(echo "$2" | jq -r '.[0].login.password')"
      ;;
  esac
}

# Type email and/or password
# $1: The string to type
type_word() {
  "${AUTOTYPE_MODE[@]}" type "$1"
}

# Emulate tab press
type_tab() {
  "${AUTOTYPE_MODE[@]}" key Tab
}

clipboard_set() {
  case "$CLIPBOARD_MODE" in
    "xclip")
      xclip -selection clipboard -r
      ;;
    "xsel")
      xsel --clipboard --input
      ;;
    "wayland")
      wl-copy
      ;;
  esac
}

clipboard_get() {
  case "$CLIPBOARD_MODE" in
    "xclip")
      xclip -selection clipboard -o
      ;;
    "xsel")
      xsel --clipboard
      ;;
    "wayland")
      wl-paste
      ;;
  esac
}

clipboard_clear() {
    case "$CLIPBOARD_MODE" in
    "xclip")
      echo -n "" | xclip -selection clipboard -r
      ;;
    "xsel")
      xsel --clipboard --delete
      ;;
    "wayland")
      wl-copy --clear
      ;;
  esac
}

# Copy an item field to clipboard
# $1: Type of copy operation
# $2: JSON array of items
copy_to_clipboard() {
  case "$1" in

    "pass")
      pass="$(echo "$2" | jq -r '.[0].login.password')"
      echo -n "$pass" | clipboard_set
      show_notification "Password Copied!"
      if [[ $CLEAR -gt 0 ]]; then
        sleep "$CLEAR"
        if [[ "$(clipboard_get)" == "$pass" ]]; then
          clipboard_clear
        fi
      fi
      ;;

    "totp")
      id=$(echo "$2" | jq -r ".[0].id")
      if ! totp=$(bw --session "$SESSION_TOKEN" get totp "$id"); then
        #exit_error 1 "Error: This item does not have a totp"
        show_notification "No TOTP for this login"
      else
        echo -n "$totp" | clipboard_set
        show_notification "TOTP Copied"
      fi
      ;;

  esac
}

# Lock the vault by purging the key used to store the session token
lock_vault() {
  keyctl purge user bw_session &>/dev/null
}

# Show context specific notification
# $1: The message of the notification
show_notification() {
  local title="Bitwarden Rofi"
  local body="$1"

  notify-send -u normal -a "$title" "$body"
}

# Ensure there is an entry names tmp file
[ ! -f "$ENTRY_NAMES_DIR" ] && touch $ENTRY_NAMES_DIR && chmod a-rwx,u+rw $ENTRY_NAMES_DIR

# Ensure requirements are met
[ ! -f "/usr/bin/bw" ] && exit_error 1 "Bitwarden CLI not found, Please install it."
[ ! -f "/usr/bin/keyctl" ] && exit_error 1 "keyctl not found, Please install keyutils."
[ ! -f "/usr/bin/$CLIPBOARD_MODE" ] && exit_error 1 "$CLIPBOARD_MODE not found. Please install it."

get_session_key
load_items
show_items