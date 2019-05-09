<br /><br />
<center>
<p align="center"><img width=85% src="https://i.gyazo.com/df46bdf4118008c3a4efaee19cb9f3fd.png"></p>
</center>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ![Swift](https://img.shields.io/cocoapods/p/testing.svg?color=red) ![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg) ![Maintenance](https://img.shields.io/maintenance/yes/2019.svg) [![Discord](https://img.shields.io/discord/370338751437733898.svg)](https://discord.gg/Ht5hfE7) [![Twitter Follow](https://img.shields.io/twitter/follow/tangoworldwide.svg?style=social&label=Follow)](https://twitter.com/TangoWorldWide)

## Basic Overview
*In a galaxy far far away* phones were being tossed in the toliet, stolen, and Apple's updates were corrupting file-systems... a new backup solution was needed, so we brought you ib2d2. b2d2 leveraged BackBlaze's affordable file hosting. ib2d2 uses the same BackBlaze B2 Cloud Storage to keep your files and memories safe. ib2d2 talks to the B2 API to send images and videos. You can view those assets in the app from the 'Browse' tab, or on the BackBlaze website!

What's better than two copies of data? __Three__.

## Key Features
* Browse your backups right from your device
* Hash comparisons to ensure backup reliability
* Seperate networking thread for uploads
* Easy to configure Settings tab; just copy and go
* Native web handling from Swift
* Lossless compression of media
* Files encrypted in transit (https)

## How It Works
Install the App on your device and head over to the 'Settings' tab! Here, you can paste in your settings from BackBlaze.com. These settings **MUST** be set before uploading files.

1. Visit the BackBlaze.com Website & Sign In
2. Head over to the **Billing** tab and add your payment information for *B2 Cloud Storage*
3. Go to the **Buckets** tab and create a new *private* bucket (e.g., "ib2d2-backups")
4. Click on **'Show Account ID and Application Key'** at the top of the page
5. Create a new key constrained to the bucket you just made
6. Copy the bucketName, applicationKeyId, applicationKey into the Settings tab on your App
7. Upload your files and you can view them in-app or under the **Buckets** tab

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
* Backup 2FA information
* ???
