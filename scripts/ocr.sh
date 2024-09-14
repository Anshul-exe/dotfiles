#!/bin/env bash

imagefile="/tmp/OCRshitz/sloppy.$RANDOM.png"
text="/tmp/OCRshitz/translation.txt"
echo "$imagefile"
slop=$(slop -f "%g") || exit 1
read -r G <<<$slop
import -window root -crop $G $imagefile
tesseract $imagefile "${text%.txt}" 2>/dev/null # Remove .txt from $text before passing to tesseract
cat "$text" | xclip -selection c                # Read directly from translation.txt
rm "$imagefile"                                 # Remove the image file after use
