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
