<br /><br />
<center>
<p align="center"><img width=85% src="https://i.gyazo.com/6f45d4774b6a07003b33fea5a8ec38b3.png"></p>
</center>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ![Python](https://img.shields.io/badge/python-v2.7%20%2F%20v3.6-blue.svg) ![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg) ![Maintenance](https://img.shields.io/maintenance/yes/2017.svg) [![Discord](https://img.shields.io/discord/370338751437733898.svg)](https://discord.gg/Ht5hfE7) [![Twitter Follow](https://img.shields.io/twitter/follow/tangoworldwide.svg?style=social&label=Follow)](https://twitter.com/TangoWorldWide)

## Basic Overview
*In a galaxy far far away* a new backup solution was needed, so we brought you b2d2. Droid's (clients) will talk to their master host and upload backups by a user-defined json file. Upon receiving a backup, the master will hold the data on server, and offload to BackBlaze for maximum redundancy. 

What's better than two copies of data? __Three__.

## Key Features
* Loads of users with sudo? Yuck! Don't share your B2 API Key on server, offload backups to the master.
* Master supports hash comparison for upload, saving you space!
* Multi-threading support for server
* Mac and Linux ready out of box
* Easy to use configuration files & backup handling
* Whitelist protection of server to keep the bad-guys out
* Native B2 integration from official client

## Install
Install is simple, each instance supports a "First Time Setup" to get you started! All information will be generated here, don't forget to edit the **IDENTIFIER** section of your config before FTSU is executed.

#### Master:
```bash
$ pip3 install --upgrade b2
$ python3 master.py --ftsu
```
#### Droid:
```bash
$ python3 droid.py --ftsu
```

## Usage
Before running the commands found in usage, we suggest you read our entire README to understand how configuration files, whitelisting, and backup definitions work during routine calls.
####Master:
Master will wait for new clients to connect, receive it's backup files, and upload to BackBlaze. Master constantly listens and polls new clients, making standup of the server easy. After running FTSU, proceed with the following. We suggest running in a screen for convenience.
```bash
$ python3 master.py
```

#### Droid:
Using a unix based system? Add a new system user which will be in the groups of each user's content you wish to backup. Then run the droid on crontab per that user. Example to follow:
```bash
$ useradd -s /usr/sbin/nologin -r -M -d /srv/backups backups
$ adduser backups <existing user>
$ crontab -e -u backups
# Add the following (This droid backs up at 4:00 daily)
# * 0 4 * * * python3 /srv/backups/droid.py >/dev/null 2>&1
```

## Droid backup definitions
Backups are simple with json files! Define each backup in the items array. Add new backups to `backups.json` on each droid: 
```json
{
  "items": [
    {
      "name": "Personal-Website",
      "paths": [
        "/srv/http/myWebsite",
        "/etc/nginx/sites-available/myWebsite.conf"
      ],
      "exclude": [
        "Feature not yet implemented"
      ]
    },
    {
      "name": "Programs",
      "paths": [
        "/home/b2d2/programs"
      ],
      "exclude": [
        "Feature not yet implemented"
      ]
    }

  ]
}
```
## Configuration
Each instance (droid(s) or master) listen to their `.ini` file to load proper settings.

#### master-config.ini:
```diff
+ LOCALSTORE: what folder to store files on the machine
+ KEEP_FILES: Amount of files to keep on local system
+ RUN_PORT: Port to bind master server to
+ WHITELIST: where to load whitelisted droids (json file)
+ B2KEY: B2 Account Key
+ B2AUTH: B2 Authorization ID
+ BUCKET: B2 Bucket to store backups in
+ THREADS: Threads to run upload to B2 with
```

#### droid-config.ini:
```diff
+ LOCALSTORE: what folder to store files on the machine
+ RUNMODE: to run in standalone or remote mode for droids
+ IDENTIFIER: name of the current server (ie: web-server) * SHOULD BE UNIQUE
+ BACKUPFILE: where to load backup definitions from (json file)
+ SERVERADDR: Define master IP
+ SERVERPORT: Define master Port

Standalone Support (Not yet implemented)
- B2KEY: B2 Account Key
- B2AUTH: B2 Authorization ID
- KEEP_FILES: Amount of files to keep on system.
```

## Master Whitelist protection
Want to backup from a new client? Add their public IP to your whitelist's json file `whitelist.json` on the master:
```json
{
  "whitelist": [
    "10.0.0.0",
    "10.0.0.1"
  ]
}
```

## Credits
* [BackBlaze](https://www.backblaze.com/): API Keys, b2 command line tool

## License
Read license information in LICENSE.TXT
#### Authored by:
* **TJ Balon** - [balon](https://git.tangoworldwide.net/balon)
* **Matt Topor** - - [polak](https://git.tangoworldwide.net/polak)

## Future Work
* Implement SSL Transfer of backup from master -> droid
* Implement offload to other providors (Amazon, Google, etc)
* Implement intial security key exchange of public RSA keys
* RSA signing of messages from master -> droid protocol
* Better clean-up handling. Delete per days, not amount of files
* ???
