#!/bin/bash

# This script creates a Wofi menu to switch the input source of one or both monitors
# using ddcutil. Ensure you have wofi and ddcutil installed.

# --- USER CONFIGURATION ---
# The DDC/CI values for the input sources you want to switch to.
# Check your monitor's manual or use ddcutil getvcp 60 to find the correct value.
NEW_SOURCE_LEFT=0x05  # 0x05 is HDMI-1 for the left monitor
NEW_SOURCE_RIGHT=0x05 

# The serial numbers of your monitors.
# Use ddcutil detect to find these values.
SERIAL_LEFT="4791210007933"
SERIAL_RIGHT="4959910002735"

# --- SCRIPT LOGIC ---
# Define the options for the Wofi menu.
# The keys are the display text, the values are used for internal logic.
declare -A options=(
    ["Left (l)"]="left"
    ["Right (r)"]="right"
    ["Both (b)"]="both"
)

# Generate the menu string for Wofi.
menu_string=$(printf "%s\n" "${!options[@]}")

# Use Wofi to get the user's selection.
selected_option=$(echo -e "$menu_string" | wofi --show dmenu --prompt "Choose Monitor:" --cache-file /dev/null)

# Exit if no option was selected.
if [ -z "$selected_option" ]; then
    echo "No option selected. Exiting."
    exit 0
fi

# Get the internal argument from the selected display text.
argument="${options[$selected_option]}"

# Use a case statement to perform the correct action based on the selection.
if [ -n "$argument" ]; then
    echo "Switching monitor source(s)..."
    case "$argument" in
        "left")
            ddcutil setvcp 60 $NEW_SOURCE_LEFT --sn="$SERIAL_LEFT"
            ;;
        "right")
            ddcutil setvcp 60 $NEW_SOURCE_RIGHT --sn="$SERIAL_RIGHT"
            ;;
        "both")
            ddcutil setvcp 60 $NEW_SOURCE_LEFT --sn="$SERIAL_LEFT"
            ddcutil setvcp 60 $NEW_SOURCE_RIGHT --sn="$SERIAL_RIGHT"
            ;;
        *)
            echo "Error: Invalid option selected."
            exit 1
            ;;
    esac
else
    echo "Error: No valid argument found for the selected option."
    exit 1
fi
