# Periscope Downloader v2.1
A Windows batch script that helps download Periscope.tv replays and live streams

#### Installation:
* download [cURL executable](http://curl.haxx.se/download.html#Win32) and copy `curl.exe` to `_bin`
* download [jq executable](https://stedolan.github.io/jq/) and copy `jq.exe` to `_bin`
* download [aria2 executable](http://sourceforge.net/projects/aria2/files/stable/aria2-1.19.0/) and copy `aria2c.exe` to `_bin`
* download [FFmpeg executable](http://ffmpeg.zeranoe.com/builds/) and copy `ffmpeg.exe` to `_bin`

#### All-in-one package:
You can download a zip archive containing the script and all the libraries (32-bit versions) from here ([VirusTotal results](https://www.virustotal.com/en/file/9cd2b7d59892898569057573755203da77321d247022663eabc04b758ef6dda1/analysis/1447254762/)):
* https://drive.google.com/file/d/0B_x__uIHJMFxR3BadmFvZ0prRzA/view
* https://yadi.sk/d/6f0QpY1hkPPUd
* https://cloud.mail.ru/public/28fVydacWv2D/Periscope_v2.1.zip

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
