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

export ONEDRIVE_REAUTH=1 
export ONEDRIVE_LOGOUT=0

# https://github.com/abraunegg/onedrive/blob/master/docs/docker.md#6-first-run-of-docker-container-under-docker-and-performing-authorisation

ONEDRIVE_DATA_DIR="${HOME}/OneDrive"

# these should both be 1000
ONEDRIVE_UID=`id -u`
ONEDRIVE_GID=`id -g`

# https://github.com/abraunegg/onedrive/blob/master/docs/docker.md#6-first-run-of-docker-container-under-docker-and-performing-authorisation

# KEY to change: make sure to specify the volume that docker compose is looking for
# - onedrive-linux-docker_onedrive_conf NOT onedrive_conf
docker run -it -v onedrive-linux-docker_onedrive_conf:/onedrive/conf \
    -v "${ONEDRIVE_DATA_DIR}:/onedrive/data" \
    -e "ONEDRIVE_UID=${ONEDRIVE_UID}" \
    -e "ONEDRIVE_REAUTH=${ONEDRIVE_REAUTH}" \
    -e "ONEDRIVE_LOGOUT=${ONEDRIVE_LOGOUT}" \
    -e "ONEDRIVE_GID=${ONEDRIVE_GID}" \
    driveone/onedrive:edge
# tip: bind some key to $TERMINAL -e onedrive_log. really convinient
