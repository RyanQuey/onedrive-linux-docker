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

export ONEDRIVE_RESYNC=0
export ONEDRIVE_REAUTH=0
export ONEDRIVE_VERBOSE=0
export ONEDRIVE_LOGOUT=0

PROJECT_DIR=$SCRIPT_DIR/..

# note that an alternative to this, is just to start the container in daemon mode (-d), and then get logs separately (`docker logs -f`)
cd $PROJECT_DIR && \
docker-compose up -d && \ 
$SCRIPT_DIR/pretty-log.sh
