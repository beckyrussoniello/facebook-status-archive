Facebook Status Archive
=======================

Description
-----------

Facebook Status Archive is a tool that lets users archive old Facebook statuses, and either view them online or download them in Rich Text.  The app remembers when each user last requested data, allowing returning users to pick up right where they left off.

I used Facebooker2 and Formtastic in building this app.

How it is used
--------------

When a user first navigates to http://archive-fb.com, they see a brief description of the app, an invitation to log in with Facebook Connect, and a Like box from Facebook (which is shown at the bottom of every page).  After they are logged in, the login button is replaced by a logout link, and a simple form is displayed, prompting users to select an output format and click "Get my statuses!"  There is also an unobtrusive Ajax link to "choose dates +".  Upon clicking this link, the form expands to display drop-down menus for the beginning and end dates of the period they'd like to archive.

If the user requests their statuses in HTML, the app redirects to the Show page, which displays all of their statuses, kind of like a diary.  If they choose RTF, the app initiates a download of the statuses in RTF.

On subsequent visits to the site, the logged-in version of the main page will be different.  Instead of the app description, it will display a Past Activity section listing up to three of the user's past data requests.  The user can view already-archived statuses by clicking a link on each of these listings.  There is also a link to the Past Activity page, which displays all of a user's past activity. 

Models
-------------

### User
The User model stores information about individual Facebook users.  The app remembers users so that it can continue to provide access to data that was already requested, and so that it can provide returning users the option to seamlessly pick up where they left off.  The User model has_many Apicalls and has_many Statuses.
	
> ++++++++++++++++ SCHEMA +++++++++++++++++++++++++++++++<br />
> create_table "users", :force => true do |t|<br />
>    t.integer "fb_id",      :null => false<br />
>    t.string  "name",       :null => false<br />
>    t.string  "first_name"<br />
>    t.string  "last_name"<br />
> end

### Apicall
The Apicall model class is basically a wrapper for the parameters a user specifies before requesting status data.  This information is used to call the Facebook Graph API, and also to instruct the app on what to do next once the data is received. The model also stores info about WHEN the user made a data request.  This enables the app to later determine where the user "left off" in recording their statuses.  **Apicall = data request.**  That the Apicall "has many" Statuses means that this model also _groups_ the Statuses, by the occasion on which they were requested.  Apicall also belongs_to User.  

> ++++++++++++++++ SCHEMA ++++++++++++++++++++++++++++++++<br />
>  create_table "apicalls", :force => true do |t|<br />
>    t.integer  "user_id",       :null => false<br />
>    t.datetime "created_at"<br />
>    t.datetime "updated_at"<br />
>    t.string   "access_token"<br />
>    t.string   "since"<br />
>    t.string   "until"<br />
>    t.boolean  "left_off"<br />
>    t.string   "output_format"<br />
>  end

The model validates the presence and format of :output_format.  It must be either "HTML" or "Rich Text".

### Status
The Status model stores information about an individual Facebook status.  Each Status belongs_to a User.  Users request statuses in units called Apicalls, so Statuses also belong_to Apicalls.

> ++++++++++++++++ SCHEMA ++++++++++++++++++++++++++++++++<br />
>  create_table "statuses", :force => true do |t|<br />
>    t.integer  "user_id",         :null => false<br />
>    t.integer  "apicall_id",      :null => false<br />
>    t.string   "message",         :null => false<br />
>    t.datetime "datetime",        :null => false<br />
>    t.string   "datetime_string"<br />
>  end

Controllers
------------

### Users Controller
* `post_callback` - parses the cookie from Facebook after the user logs in with Facebook Connect.  For first-time users, it creates a new model instance with their Facebook info.  Then, it sets the user's session information.
* `past_activity` - allows a logged-in user to view their own past activity.
* `logout` - clears session data and redirects to the logged-out version of the main page.
### Welcome Controller
* `index` - sets instance variables for the main page.
### Apicalls Controller
* `create` - uses form data to populate an Apicall instance.
* `rtf` - generates an RTF document with the user's statuses and sends it to the user.
* `show` - shows all the statuses in an Apicall.
* `match_user` - before filter; ensures that a user deals only with their own Apicalls.
### Status Controller
* `create_statuses` - gets status data from Facebook in the form of JSON.  Parses this data, and uses it to populate a Status instance for each status in the JSON response.


Modules
--------

Three lib modules help Status Archive work:
### JsonParser
This module deals with acquiring status data from the Facebook Graph API.  The URL for an API call always begins with https://graph.facebook.com/me/statuses -- we will call this the BASE_URL.  An access token (unique for every session) must be appended. Additional parameters (such as "since" and "until") are optional.  Once the URL is constructed, we curl that page.  The data is received as JSON, which is then parsed and returned to the controller.  The method 'JsonParser.get_status_attributes' performs more specialized parsing on each individual status -- ultimately returning a hash which is used to initialize a Status object.
### DateFormatter
Performs various functions related to changing the format of dates: creates a "diary"-like string out of a status' datetime; determines the date to use when a user wants to "pick up where I left off"; finds month names based on numbers; handles regexes; etc.
### FormatRtf
This module takes a set of statuses and uses the ruby-rtf plugin to create an RTF document which displays them.  The resulting document has a header, a separate "paragraph" for each status (which displays the date, time, and status message), and a link to archive-fb.com at the end.  The finished document is returned to the controller.
