#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR=$SCRIPT_DIR/..

# clear out these vars, if set already before
export ONEDRIVE_REAUTH=0
export ONEDRIVE_LOGOUT=0


# this is the crucial element of course
export ONEDRIVE_RESYNC=1 

# optional, depending on how much you want to see. If you don't set it though, it will let you know you successfully started the run, that's it. 
#export ONEDRIVE_VERBOSE=0
export ONEDRIVE_VERBOSE=1

# at least for these (MAYBE WITH OTHERS!?) you need to make a new container for it to pick up on the new options, so just kill the old container. 
docker stop onedrive-linux-docker_onedrive_1 && \
docker rm onedrive-linux-docker_onedrive_1 && \
cd $PROJECT_DIR && \
docker-compose up -d && \
$SCRIPT_DIR/pretty-log.sh

