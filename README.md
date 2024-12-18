
There's a better way to do this...but I'm not sure what it is. 

https://github.com/abraunegg/onedrive/blob/master/docs/docker.md

# Setup
0) Make sure existing pre-reqs are correct

See
[this](https://github.com/abraunegg/onedrive/issues/2562#issuecomment-1859229723)
> This 'config' problem stems from using 'OneDriveGUI' that incorrectly writes
> out empty configuration items. If you are using this, and using 'alpha-3' -
> you need to update your GUI to this:
> https://github.com/bpozdena/OneDriveGUI/releases/tag/v1.1.0alpha0


So, need to remove `drive_id` from configs

1) Start container in `-it` (interactive tty mode)

So, first just start the container, and then let it wait for you:


```
docker-compose up
```

2) Then as it's waiting, copy in the files
```
# docker cp /home/ryan/.config/onedrive/ "onedrive-linux-docker_onedrive_1:/onedrive/conf"
docker cp /home/ryan/projects/onedrive-linux-docker/configs/config "onedrive-linux-docker_onedrive_1:/onedrive/conf/"
docker cp /home/ryan/projects/onedrive-linux-docker/configs/sync_list "onedrive-linux-docker_onedrive_1:/onedrive/conf/"
# optional, but saves time.
docker cp /home/ryan/.config/onedrive/refresh_token "onedrive-linux-docker_onedrive_1:/onedrive/conf/
```

3) Close the container

```
ctrl-c
```

4) Then, restart container, which should now have all the right config files
```
docker start onedrive-linux-docker_onedrive_1
```


# Other operations

- Taking cue often from:
https://github.com/abraunegg/onedrive/blob/master/docs/docker.md#environment-variables-usage-examples
  - Gives instructions regarding running one-off containers from the image,
    which make use of existing volume. 

## How to: Run a re-auth
https://github.com/abraunegg/onedrive/blob/master/docs/docker.md#6-first-run-of-docker-container-under-docker-and-performing-authorisation

> When the Docker container successfully starts:
> - You will be asked to open a specific link using your web browser
> - Login to your Microsoft Account and give the application the permission
> - After giving the permission, you will be redirected to a blank page
> - Copy the URI of the blank page into the application prompt to authorise the application

Key is, copy the blank page into the prompt

## How to: Run a re-sync
- THere's probably a wya to do this with existing containers. But this also
  works fine:


  ```
docker container run -e ONEDRIVE_RESYNC=1 -e ONEDRIVE_VERBOSE=1 -v onedrive-linux-docker_onedrive_conf:/onedrive/conf -v "/home/ryan/OneDrive:/onedrive/data" driveone/onedrive:edge
  ```

## Setup with OneDrive GUI
DOESN'T SEEM TO WORK
- I think I would need to run it in Docker as well or something - would also
  need to see how the GUI communicates with teh process normally. 
- When I tried, it says that there is no running process, so for whatever reason
  OneDriveGUI couldn't detect it when running in docker.


### 1) set profile to point to project (aka mounted volume for conf) config file


```
vim .config/onedrive-gui/profiles

# then in vim, change it to this:
...
config_file = /home/ryan/projects/onedrive-linux-docker/configs/config
...
```

Note that unlike the Onedrive client itself, it needs this key:
```
monitor_fullscan_frequency = "10"
log_dir = "/var/log/onedrive/"
min_notify_changes = ""
``` 
- log_dir, I think Onedrive will just ignore it. It says in the docker logs,
  that dir doesn't exist, so defaults to somewhere else. 
(Or some such number, this is default though I think)

### 2) Run it

E.g., if put in `/opt/OneDriveGUI.AppImage` (as I did on Dell Optiplex)




# Appendix 1 - Debugging
## Check what's in that config file on a downed container
If not down, and restarting, you might need to manually stop it first so it's
startable


```
docker stop onedrive-linux-docker_onedrive_1
```

Then, 

```
docker stop onedrive-linux-docker_onedrive_1 && \
docker start onedrive-linux-docker_onedrive_1 && docker exec -it
onedrive-linux-docker_onedrive_1 cat /onedrive/conf/config
```

## ERROR: Check your configuration as your existing refresh_token generated an invalid request. You may need to issue a --reauth and re-authorise this client.


```
./scripts/logout-and-reauth.sh
```

### NOTE YOU ALSO NEED TO CHECK "drive_id" key
- If set to something wrong, then it can show this error too. 

```
Enter the response uri from your browser: https://login.microsoftonline.com/common/oauth2/nativeclient?code=[code]
User Configured Rate Limit: 125000000

ERROR: Check your configuration as your existing refresh_token generated an invalid request. You may need to issue a --reauth and re-authorise this client.

Unable to query OneDrive API to obtain required account details

```
It's not ALWAYS an auth problem though, it's that you set the "drive_id" to something
wrong!!

## Parental Path structure needs to be created to support included file: Notes/work.ministry/ continuing_edu/PhD/PhD-topics/Phd-topic-Lev Isa Luke/unsorted articles/Shelberg-BOOK Cleansed Lepers, Cl ansed Hearts
- You might see these in the verbose logs when it's syncing. Don't be concerned:
  it might not mean anything. This also shows when there already is that folder
  directory, at least from my experience, and it still worked fine

## A database statement execution error occurred: NOT NULL constraint failed:
item.type
```
nedrive_1  | A database statement execution error occurred: NOT NULL constraint failed: item.type      
nedrive_1  |                                                                                           
nedrive_1  | Please restart the application with --resync to potentially fix any local database issues.
nedrive_1  |                                                                                           
nedrive_1  | A database statement execution error occurred: FOREIGN KEY constraint failed               nedrive_1  |                                                                                           
nedrive_1  | Please restart the application with --resync to potentially fix any local database issues.
```


- This when running the sync
- Mostly it happens when a file with strange characteristics appears, I think, and OneDrive doesn't know what to do with it. 
- I'm not sure, but it doesn't error out, so I'm assuming OneDriveLinux just skips it. 
