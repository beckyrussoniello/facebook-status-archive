require 'test_helper'
require 'test/mocks/test/integration/json_parser.rb'


class UserArchivesStatusesTest < ActionController::IntegrationTest
  fixtures :all

  def setup
    @chris = 					users(:chris)
    @becky = 					users(:becky)
    @mary = 					{ :name => "Mary Smith", 
						  :first_name => "Mary", 
						  :last_name => "Smith", 
						  :fb_id => 555555, :id => 5 }

    @access_token = 				"valid_access_token"

    @simple_apicall_with_html = 		{ :output_format => "HTML", 
						  :left_off => false }
    @apicall_with_since_and_until = 		{ :output_format => "Rich Text", 
						  :left_off => false, 
						  :"since(1i)" => "2009", 
						  :"since(2i)" => "4", 
						  :"since(3i)" => "11", 
						  :"until(1i)" => "2010", 
						  :"until(2i)" => "10", 
						  :"until(3i)" => "8"}
    @apicall_with_html_and_checkbox = 		{ :output_format => "HTML", 
						  :left_off => "1" }
    @apicall_with_since_until_and_checkbox = 	{ :output_format => "Rich Text", 
						  :left_off => "1", 
						  :"since(1i)" => "2009", 
						  :"since(2i)" => "6", 
						  :"since(3i)" => "10", 
						  :"until(1i)" => "2010", 
						  :"until(2i)" => "9", 
						  :"until(3i)" => "1"}
    @rtf_apicall_with_since = 			{ :output_format => "Rich Text", 
						  :left_off => false, 
						  :"since(1i)" => "2010", 
						  :"since(2i)" => "7", 
						  :"since(3i)" => ""}
  end

# NEW USER ARCHIVES STATUSES IN HTML
  test "new user archives statuses in HTML" do
    # A user goes to archive-fb.com.
    mary = regular_user
    mary.is_viewing_the_main_page
    # They log in.  Because they have never used Status Archive before, the 
    # index displays a description of the app rather than the Past Activity 
    # section.  The new apicall form is also displayed.
    mary.logs_in_for_the_first_time(@mary)
    mary.sees_app_description_and_new_apicall_form
    # The user selects HTML from the drop-down menu and hits the submit button.
    mary.requests_statuses_in_html(@simple_apicall_with_html) 
    # The apicall is created.  Its user_id matches the user.  Now the user has 
    # one apicall.
    mary.now_has_one_apicall
    # The app renders apicalls/show, and the user sees their statuses displayed 
    # on the page.
    mary.views_their_new_statuses_in_html
    # The app created a Status for every status in the JSON response from 
    # Facebook.
    mary.received_all_the_statuses_that_they_should_have
    # The user clicks "back" to go back to the main page.  Now it displays the 
    # Past Activity section.
    mary.is_viewing_the_main_page
    mary.sees_past_activity_section_and_new_apicall_form
    # They log out.
    mary.logs_out
  end

# RETURNING USER ARCHIVES STATUSES IN RICH TEXT
  test "returning user archives statuses in Rich Text" do
    # A returning user logs into the app.  Since they've used Status Archive 
    # before, the index displays the Past Activity section rather than a 
    # description of the app.  The new apicall form is also displayed.
    chris = regular_user
    chris.logs_in(@chris)
    chris.sees_past_activity_section_and_new_apicall_form
    # They select Rich Text format, a "since" date of April 11, 2009, and an  
    # "until" date of October 8, 2010.  They click the submit button.  
    # The app initiates a download of the statuses.
    chris.requests_statuses_in_rtf(@apicall_with_since_and_until) 
    # The file, status_archive.rtf, contains all the statuses that it should. 
    chris.received_all_the_statuses_that_they_should_have
  end

# VIEW PAST ACTIVITY
  test "view past activity" do
    # A logged in, returning user is viewing the main page, which has the Past 
    # Activity section with a link to "view all past activity".
    chris = regular_user
    chris.logs_in(@chris)
    chris.sees_past_activity_section_and_new_apicall_form
    # They click this link, which triggers the "past_activity" action.  
    # They see all of their previous apicalls listed.  The template is 
    # users/past_activity.
    chris.views_past_activity
  end

# PICK UP WHERE I LEFT OFF
  test "pick up where I left off" do
    # A logged in, returning user is viewing the main page.
    chris = regular_user
    chris.logs_in(@chris)
    # They choose "HTML", and check the checkbox for "Pick up where I left  
    # off".  They submit the form.
    chris.requests_statuses_in_html(@apicall_with_html_and_checkbox)
    # An apicall is created.  The "since" value is the same as the "created_at" 
    # value of the user's most recent previous apicall. The app redirects to 
    # status/create_statuses.  Only statuses from the "since" date and later are 
    # included.  
    chris.received_all_the_statuses_that_they_should_have
    #Finally, the app redirects to apicalls/show/#{id} and the user 
    # sees their statuses.
    chris.views_their_new_statuses_in_html
  end

# SINCE AND UNTIL WITH CHECKBOX CHECKED
  test "since and until with checkbox checked" do
    chris = regular_user
    chris.logs_in(@chris)
    # A logged in user requests statuses in Rich Text, and checks the "pick up 
    # where I left off" checkbox.  They ALSO select a "since" date of June 10, 
    # 2009 and an "until" date of September 1, 2010.
    chris.requests_statuses_in_rtf(@apicall_with_since_until_and_checkbox)
    # The apicall is created.  THE APP IGNORES THE SINCE AND UNTIL VALUES, 
    # instead only paying attention to "pick up where I left off".  It assigns
    # a "since" value equal to the "created_at" value of the user's previous 
    # apicall.
    # The statuses are created, and an rtf download is initiated. 
    chris.received_all_the_statuses_that_they_should_have 
  end

# LOGOUT AND LOG BACK IN AS SOMEONE ELSE
  test "logout and log back in as someone else" do
    # A user logs in and views the main page.  
    two_users_on_shared_computer = regular_user
    two_users_on_shared_computer.logs_in(@chris)
    # They click "logout" and session[:user_id] becomes nil.  The logged
    # out version of the main page is now being displayed.
    two_users_on_shared_computer.logs_out
    # Someone else on the same computer logs in.  Session[:user_id] is set;
    # the screen once again displays the logged in version of the main page.
    two_users_on_shared_computer.logs_in(@becky)
  end
end

