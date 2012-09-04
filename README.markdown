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

### User
	
 Schema:
        create_table "users", :force => true do |t|
          t.integer "fb_id",      :null => false
          t.string  "username",       :null => false
          t.string  "first_name"
          t.string  "last_name"
	  t.string  "image_url"
	  t.string  "oauth_token"
	  t.datetime  "last_login_at"
          t.datetime "created_at",    :null => false
          t.datetime "updated_at",    :null => false
        end

### Archive
The Archive model class is basically a wrapper for the parameters a user specifies before requesting status data.  This information is used to call the Facebook Graph API, and also to instruct the app on what to do next once the data is received. The model also stores info about _when_ the user made a data request.  This enables the app to later determine where the user "left off" in recording their statuses.

 Schema:
        create_table "archives", :force => true do |t|
          t.integer  "user_id"
          t.date     "start_date"
          t.date     "end_date"
          t.datetime "created_at",       :null => false
          t.datetime "updated_at",       :null => false
          t.integer  "output_format_id"
        end

### Status

 Schema:
        create_table "statuses", :force => true do |t|
          t.integer  "user_id"
          t.integer  "archive_id"
          t.datetime "timestamp"
          t.datetime "created_at", :null => false
          t.datetime "updated_at", :null => false
          t.string   "message"
        end

Controllers
------------

### Users Controller
* `post_callback` - parses the cookie from Facebook after the user logs in with Facebook Connect.  For first-time users, it creates a new model instance with their Facebook info.  Then, it sets the user's session information.
* `past_activity` - allows a logged-in user to view their own past activity.
* `logout` - clears session data and redirects to the logged-out version of the main page.</ul>
### Welcome Controller
* `index` - sets instance variables for the main page.</ul>
### Apicalls Controller
* `create` - uses form data to populate an Apicall instance.
* `rtf` - generates an RTF document with the statuses in an Apicall and sends it to the user.
* `show` - shows all the statuses in an Apicall.
* `match_user` - before filter; ensures that a user deals only with their own Apicalls.</ul>
### Status Controller
* `create_statuses` - gets status data from Facebook in the form of JSON.  Parses this data, and uses it to populate a Status instance for each status in the JSON response.


FormatRtf Module
----------------
This module takes a set of statuses and uses the [ruby-rtf](http://ruby-rtf.rubyforge.org/) plugin to create an RTF document which displays them.  The resulting document has a header and a separate paragraph for each status (which displays the date, time, and status message).
