Facebook Status Archive
=======================

Description
-----------

Facebook Status Archive is a tool that lets users archive old Facebook statuses, and either view them online or download them in Rich Text. 

I used [Omniauth](https://github.com/intridea/omniauth/) and [Koala](https://github.com/arsduo/koala/) in building this app.

How it is used
--------------

Users choose whether to view their statuses in HTML or download an RTF.  Optionally, they may choose start and end dates.  By default, the app shows all statuses available.

If the user requests their statuses in HTML, the app redirects to the Show page, which displays all of their statuses, kind of like a diary.  If they choose RTF, the app initiates a download of the statuses in RTF.

Models
-------------

* `User`
* `Archive` - a wrapper for the parameters a user specifies when requesting status data.  Also records _when_ the request was made, so we don't duplicate our work next time.
* `Status`

Controllers
------------

### Application Controller
* `find_user` - before filter; maintains the session and redirects to OmniAuth as necessary.</ul>
              
### Welcome Controller
* `login` - receives user info from OmniAuth; creates user if necessary; sets user id in session and updates oauth token.
* `index` - sets instance variables for the main page.</ul>
          
### Archives Controller
* `create` - uses form data to populate an Archive instance.
* `show` - displays statuses or initiates RTF download.</ul>


FormatRtf Module
----------------
This module takes a set of statuses and uses the [rtf](https://github.com/thechrisoshow/rtf/) gem to create an RTF document which displays them.  The resulting document has a header and a separate paragraph for each status (which displays the date, time, and status message).
