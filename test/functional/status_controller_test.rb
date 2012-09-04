require "test_helper"
require "rexml/document"

class StatusControllerTest < ActionController::TestCase

  def setup
    @chris = users(:chris)
    @expected_flash_notice = ("Your access token seems to have expired.  Try " +
				"logging out and logging back in again; then " +
				"everything should work.")
  end

# CREATE STATUSES WITH VALID ACCESS TOKEN
  test "create statuses with valid access token" do
   # With a valid access token, the app should create a Status object for 
   # each Facebook status.  We will test with several different apicalls 
   # (with varying parameters), and with both types of output_format.
    output_formats = ["HTML", "Rich Text"]
    for apicall in [apicalls(:three), apicalls(:four), apicalls(:five)]      
      for i in 0..1
        format = output_formats[i]
        # Measure the apicall's current number of statuses for later comparison.  
        # Should always be zero in real life, but in the testing environment, 
        # apicall fixtures may already have statuses.
        number_of_statuses_before_action = apicall.statuses.size

        post :create_statuses, { }, { :user_id => @chris.id, 
				      :apicall => apicall.id, 
				      :token => apicall.access_token }, 
				    { :format => format }
        # flash[:notice] only gets a value if the access token was invalid.
        assert_nil flash[:notice]
        # Depending on flash[:format], the app should redirect to either 
	# apicalls/show or apicalls/rtf.
        assert_response 302
        assert_equal redirect_to_url, case format
          when "HTML" then "http://test.host/apicalls/show/#{apicall.id}"
          when "Rich Text" then "http://test.host/apicalls/rtf/#{apicall.id}"
        end
        # The apicall should have more statuses now than it did before 
	# the create_statuses action.
        number_of_statuses_after_action = apicall.statuses.size
        assert number_of_statuses_after_action > number_of_statuses_before_action, 
		message = "There are now #{number_of_statuses_after_action} 
			statuses.  Used to be #{number_of_statuses_before_action}."
        # Verify that the correct number of statuses was created.
	dataset = JsonParser.get_dataset(apicall.access_token, apicall)
        assert_equal (number_of_statuses_after_action - number_of_statuses_before_action),
	    dataset.size
        # Clear the variables for the next loop.
        number_of_statuses_before_action = nil and number_of_statuses_after_action = nil
      end
    end
  end

# CANNOT CREATE STATUSES WITH EXPIRED ACCESS TOKEN
 test "cannot create statuses with expired access token" do
   # The app should not attempt to create any Statuses if the access token is 
   # invalid.  We will test this with two different apicalls, and with each 
   # type of output_format.
    output_formats = ["HTML", "Rich Text"]
    for apicall in [apicalls(:four), apicalls(:five)]      
      for i in 0..1
        format = output_formats[i]
        # The user submits an apicall with an invalid access token.
        post :create_statuses, { }, { :user_id => @chris.id, 
				      :apicall => apicall.id,
				      :token => "invalid" }, 
				    { :format => format }
        # Should redirect to the main page, without assigning session[:apicall].
        assert_response 302
        assert_equal root_url, redirect_to_url
        assert_nil session[:apicall]
        # Should inform the user via flash[:notice] that their access token 
	# has expired.
         assert_equal @expected_flash_notice, flash[:notice]
      end
    end
  end
end
