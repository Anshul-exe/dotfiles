#!/bin/bash

quotes=(
  "Work So Hard That Luck Gets Out Of The Equation"
  "The goal isn’t more money. The goal is living life on your terms."
  "Rich people believe 'I create my life.' Poor people believe 'Life happens to me.'"
  "Money grows on the tree of persistence."
  "The only limit to your wealth is the size of your vision."
  "Success is not about making money, it’s about making a difference while making money."
  "Wealth is the ability to fully experience life."
  "Don’t wait for opportunity. Create it and profit from it."
  "The rich invest in time, the poor invest in money."
  "Money is a tool. Freedom is the goal."
)

random_index=$((RANDOM % ${#quotes[@]}))

notify-send -i /home/mir/clear_space/Media/idharUdhar/LessGooBaby.png -u low -a "Shaahi Sandesha" "Let's get the work done my Liege"
notify-send -i /home/mir/clear_space/Media/idharUdhar/money.png -u normal -a "I Got This" "${quotes[$random_index]}"
