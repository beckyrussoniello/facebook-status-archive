require 'test_helper'

  class UsingTheAppTest < ActionController::IntegrationTest
    fixtures :all

  def setup
    @chris = 			users(:chris)  
    @becky = 			users(:becky)
    @bob = 			users(:bob)
    @janice = 			{:id => 5, :name => "Janice Russoniello", 
				 :first_name => "Janice", 
				 :last_name => "Russoniello", 
				 :fb_id => 111111}
    @access_token = 		"valid_access_token"
    @simple_apicall = 		{ :output_format => "HTML", 
				  :left_off => false }
    @apicall_with_since = 	{ :output_format => "Rich Text", 
				  :left_off => false, :"since(1i)" => "2010", 
				  :"since(2i)" => "7", :"since(3i)" => ""}
  end

   test "multiple users on the site at once" do
    # Chris logs into the app.
      chris = regular_user
      chris.logs_in(@chris)
    # Becky logs in. 
      becky = regular_user
      becky.logs_in(@becky)
    # Chris selects HTML on the form, and submits.
      chris.requests_statuses_in_html(@simple_apicall)
    # Bob logs in. 
      bob = regular_user
      bob.logs_in(@bob)
    # Becky downloads an rtf file with statuses from July 2010 to the present. 
      becky.requests_statuses_in_rtf(@apicall_with_since)
    # Chris views all of his available statuses in HTML.
      chris.views_their_new_statuses_in_html
    # Bob clicks "view past activity" and is taken to users/past_activity.  
      bob.views_past_activity
    # Becky logs out.  Her session[:user_id] is cleared; the others are 
    # still there.
      becky.logs_out
      chris.is_still_there
      bob.is_still_there
    # Janice logs in to the app.  Her session[:user_id] is set.
      janice = regular_user
      janice.logs_in_for_the_first_time(@janice)
    # Chris and Bob log out.  Their session[:user_id]s are cleared.
      chris.logs_out
      bob.logs_out      
  end
end
