<br /><br />
<center>
<p align="center"><img width=85% src="https://i.gyazo.com/df46bdf4118008c3a4efaee19cb9f3fd.png"></p>
</center>

<center>
![Swift](https://img.shields.io/cocoapods/p/testing.svg?color=red) ![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg) ![Maintenance](https://img.shields.io/maintenance/yes/2019.svg) [![Discord](https://img.shields.io/discord/370338751437733898.svg)](https://discord.gg/Ht5hfE7) [![Twitter Follow](https://img.shields.io/twitter/follow/tangoworldwide.svg?style=social&label=Follow)](https://twitter.com/TangoWorldWide)
</center>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ![Swift](https://img.shields.io/cocoapods/p/testing.svg?color=red) ![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg) ![Maintenance](https://img.shields.io/maintenance/yes/2019.svg) [![Discord](https://img.shields.io/discord/370338751437733898.svg)](https://discord.gg/Ht5hfE7) [![Twitter Follow](https://img.shields.io/twitter/follow/tangoworldwide.svg?style=social&label=Follow)](https://twitter.com/TangoWorldWide)

## Basic Overview
*In a galaxy far far away* phones were being tossed in the toliet, stolen, and Apple's updates were corrupting file-systems... a new backup solution was needed, so we brought you ib2d2. b2d2 leveraged BackBlaze's affordable file hosting. ib2d2 uses the same BackBlaze B2 Cloud Storage to keep your files and memories safe. ib2d2 talks to the B2 API to send images and videos. You can view those assets in the app from the 'Browse' tab, or on the BackBlaze website!

What's better than two copies of data? __Three__.

## Key Features
* Browse your backups right from your device
* Hash comparisons to ensure backup reliability
* Seperate networking thread for uploads
* Easy to configure Settings tab; just copy and go
* Native web handling from Swift
* File encryption on upload

## How It Works
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

## Credits
* [BackBlaze](https://www.backblaze.com/): B2 Cloud Storage

## License
Read license information in LICENSE.TXT
#### Authored by:
* **TJ Balon** - [balon](https://twitter.com/tjbalon)

## Future Work
* Full 3-2-1 using local storage & iCloud
* Progress bars for uploads and downloads of data
* Mass Upload/Download of data
* Encrypt files at rest
* URL Sharing for your files
* 'Private' files (encrypted files on device, on backblaze, etc)
* ???
