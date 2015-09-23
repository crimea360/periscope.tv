# Periscope Downloader
A Windows batch script that helps download Periscope.tv replays and live streams

#### Installation:
* download [cURL executable](http://curl.haxx.se/download.html#Win32) and copy `curl.exe` to `_bin`
* download [jq executable](https://stedolan.github.io/jq/) and copy `jq.exe` to `_bin`
* download [aria2 executable](http://sourceforge.net/projects/aria2/files/stable/aria2-1.19.0/) and copy `aria2c.exe` to `_bin`
* download [FFmpeg executable](http://ffmpeg.zeranoe.com/builds/) and copy `ffmpeg.exe` to `_bin`

#### All-in-one package:
You can download a zip archive containing the script and all the libraries (32-bit versions) from here ([VirusTotal results](https://www.virustotal.com/en/file/700c6da574f620b4aa99d798073581752e7b45baea283901d5612eff215e2922/analysis/1442796594/)):
* https://drive.google.com/file/d/0B_x__uIHJMFxQzBCNk12cmw1aW8/view
* https://yadi.sk/d/_VkM7-OxjD7my
* https://cloud.mail.ru/public/5o1H3qmLembW/Periscope_v2.0.zip

#### Features:
* downloads streams available for replay in native MPEG-TS format
* records live streams in native MPEG-TS format
* converts video to mp4 and rotates it (optional)
* multiple simultaneous downloads/recordings
* multi-threaded downloading for maximum speed
* automatic file and folder naming
* supports perisearch.net links

#### Notes:
This script uses additional batch scripts made by Dave Benham:
* [getTimestamp.bat](http://www.dostips.com/forum/viewtopic.php?p=38387) - used for converting Periscope's GMT-7 date and time to local user's time
* [JREPL.bat](http://www.dostips.com/forum/viewtopic.php?f=3&t=6044) - used for sanitizing `.user.display_name` and `.broadcast.status` (removing illegal and unwanted characters)
