#!/bin/sh

#  AllowAppToRun.sh
#  Minesweeper
#
#  Created by Nick Deupree on 12/23/23.
#  
# Get the current directory
pwdDirectory=$(pwd)

# Change the permissions of the Minesweeper executable
chmod +x "$pwdDirectory/Minesweeper.app/Contents/MacOS/Minesweeper"


# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Copy the font to the user's Fonts directory
cp "$DIR/mine-sweeper.otf" ~/Library/Fonts/
