#!/bin/sh

COLOR='#000000'
IMAGE='/home/mir/Pictures/wallpapers/FACE1.png'

i3lock -i $IMAGE -f -k \
  --clock --date-str="%A, %d %B" --time-color=ffffffff --date-color=ffffffff \
  --inside-color=00000000 --ring-color=00000000 --line-uses-inside \
  --keyhl-color=ffffffff --bshl-color=d23c3dff --separator-color=00000000 \
  --verif-color=ffffffff --wrong-color=ffffffff --verif-text="Sabar Kro..." \
  --wrong-text="Bhak! Sahi se dalo" --noinput-text="Kaha gae??" --radius=140 --ring-width=10 \
  --insidever-color=808080cc --ringver-color=808080ff --ind-pos=960:540

# i3lock -i $IMAGE -f -k --timepos="x+110:h-70" --datepos="tx+24:ty+25" \
#   --clock --date-str="%A, %d %B" --time-color=ffffffff --date-color=ffffffff \
#   --inside-color=00000000 --ring-color=ffffffff --line-uses-inside \
#   --keyhl-color=d23c3dff --bshl-color=d23c3dff --separator-color=00000000 \
#   --verif-color=ffffffff --wrong-color=d23c3dff --verif-text="Verifying..." \
#   --wrong-text="Wrong!" --noinput-text="No input" --radius=120 --ring-width=10