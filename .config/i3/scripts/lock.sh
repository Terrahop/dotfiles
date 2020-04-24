B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ff00ffcc'  # default
T='#ee00eeee'  # text
W='#880000bb'  # wrong
V='#bb00bbbb'  # verifying

i3lock \
  --show-failed-attempts \
  --screen 1            \
  --blur 4              \
  --clock               \
  --timestr="%H:%M:%S"  \
  --datestr="%A, %m %Y" \
  --indicator           \
  \
  --radius 190          \
  --ring-width 20       \
  --insidevercolor=$C   \
  --ringvercolor=$V     \
  --bshlcolor=$W        \
  \
  --insidewrongcolor=$C \
  --ringwrongcolor=$W   \
  \
  --insidecolor=$B      \
  --ringcolor=$D        \
  --linecolor=$B        \
  --separatorcolor=$D   \
  \
  --verifcolor=$T        \
  --wrongcolor=$T        \
  --timecolor=$T        \
  --datecolor=$T        \
  --layoutcolor=$T      \
  --keyhlcolor=$W       \
  \
  --bar-indicator       \
