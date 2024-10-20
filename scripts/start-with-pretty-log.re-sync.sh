#!/usr/bin/env bash

# https://github.com/zzzdeb/dotfiles/blob/master/scripts/tools/onedrive_log

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

normal=$(tput sgr0)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR=$SCRIPT_DIR/..

# clear out these, if set already before
export ONEDRIVE_REAUTH=0
export ONEDRIVE_LOGOUT=0

export ONEDRIVE_RESYNC=1 
export ONEDRIVE_VERBOSE=0
#export ONEDRIVE_VERBOSE=1

cd $PROJECT_DIR && \
docker-compose up | \
   ag -v 'Remaining free space' |                   # removing unwanted lines from log
  sed -u "s/Uploading/$(printf "${blue}Uploading${normal}")/;
          s/Successfully created/$(printf "${blue}Successfully created${normal}")/;
          s/Downloading/$(printf "${magenta}Downloading${normal}")/;
          s/Moving/$(printf "${magenta}Moving${normal}")/;
          s/Deleting/$(printf "${yellow}Deleting${normal}")/;
          s/deleted/$(printf "${yellow}deleted${normal}")/gI;
          " |                                         # changing colors of words
   ccze -A -c default=white  # |                        # nice program to colorize log
          #>> /tmp/tmp1.txt
  # ag --passthru "↗ |Stopping|Stopped|Uploading|Downloading|Error|Deleting"
          # s/error/$(printf "${red}❎ERROR${normal}")/gI;
          # s/done./$(printf "${green}✔${normal}")/

# tip: bind some key to $TERMINAL -e onedrive_log. really convinient
