#!/bin/bash

# Function to set bsp-layout
set_layout() {
    LAYOUT=$1
    WORKSPACE=$2
    bsp-layout set $LAYOUT $WORKSPACE
}

# Main dialog
CHOICE=$(yad --form --title="BSP Layout Control" \
    --field="Layout":CB "tall!wide!grid!rgrid!even!tiled!monocle" \
    --field="Workspace":NUM --button="OK":0 --button="Cancel":1)

# Check if the user pressed "OK"
if [ $? -eq 0 ]; then
    LAYOUT=$(echo $CHOICE | awk -F'|' '{print $1}')
    WORKSPACE=$(echo $CHOICE | awk -F'|' '{print $2}')
    set_layout $LAYOUT $WORKSPACE
    yad --info --text="Layout $LAYOUT has been set for workspace $WORKSPACE"
else
    yad --info --text="Operation cancelled."
fi
