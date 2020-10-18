# easy cron jobs for macOS

## Tons of examples for automating your mac

> 'cron jobs' are automatic scheduled jobs. They are automated commands that run at specified times without user intervention, allowing us to setup a huge number of things that will happen automatically.

_Although I have tested all of these thoroughly on macOS, most of the commands and syntax in the examples will work in any Unix or Linux type environment._

**Examples are found in this repo. Some examples are:**

-   automatically downloading YouTube playlists
-   daily tweet from a list of quotes or photos
-   social media updates
-   gathering social media notification counts
-   automatically responding to certain emails
-   automatically updating podcasts or playlists
-   watching websites or RSS feeds for news or political updates
-   gathering public information about political votes and posting summaries to social media or blob posts

## Administrative (`sudo`) tasks

### To create cron jobs that require root user priviledges, use

`sudo crontab -e -u root`

A selection of those scripts are in the admin folder. Some examples are:

-   empty system trash
-   update software automaitically
-   copy files
-   clear temporary (`/tmp`) files

## Parental Controls

### Incidentally, you may notice that by changing the name after the `-u` user flag, you can actually make cron jobs for any user without being logged in. I have found this handy for parental controls. Here are some ideas for parents:

---

## References:

Primary Test Environment:

-   macOS Catalina Beta
-   Ubuntu 16.04 VirtualBox
-   Docker LAMP with Python 3.7.4 / PHP 7.4 / Ruby 2.6
-   Node 12.6.0
-   MacBook Pro (Retina mid-2015)
-   16GB / 128 SSD / Intel graphics
-   BASH 5.0.7(1)-release
-   git version 2.22.0
-   hub version 2.12.2
-   ruby v2.6.3p62
-   php v7.1.23
-   python v3.7.4
-   node v12.6.0
-   npm v6.9.0
