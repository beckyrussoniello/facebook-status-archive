require 'test_helper'

class ApicallsControllerTest < ActionController::TestCase

  def setup
    @chris = users(:chris)
  end

# CAN'T VIEW ANOTHER USER'S DATA
  test "can't view another user's data" do
    # If a user tries to view an apicall that doesn't belong to
    # them, they will be redirected to the main page.
    get :show, {:id => 1}, { :user_id => @chris.id }, {}
    assert_redirected_to :controller => "welcome"
  end

# SHOW APICALL
  test "show apicall" do
    get :show, {:id => 3}, { :user_id => @chris.id }, {}
    assert_response :success
    assert_template "show"
  end

# TEST RTF
  test "rtf" do
    # This action should initiate an RTF download of the user's statuses.
    get :rtf, {:id => 3}, { :user_id => @chris.id }, {}
    assert_response(:success)
    # The response doesn't render any template; instead, it is a Proc.
    assert(@response.body.is_a? Proc)
    # We convert the output to a string in order to test its contents.
    require 'stringio'
    output = StringIO.new
    output.binmode
    assert_nothing_raised { @response.body.call(@response, output) }
    # We use the helper method rtf_string to determine an expected value
    # for the output.  Then we assert that they are equal.
    expected_string = rtf_string(@chris, 3).string
    assert_equal(expected_string, output.string)
  end

# CREATE APICALL WITH :left_off => false
  test "create apicall with :left_off => false" do
    # The user submits the new apicall form WITHOUT checking the 
    # "pick up where I left off" checkbox.
    post :create, { :apicall => @chris.apicalls.first }, 
		  { :user_id => @chris.id }, {}
    # The app should redirect to status/create_statuses
    assert_redirected_to create_statuses_url
    # flash[:format] will tell the status controller whether to proceed 
    # with HTML or RTF.  
    assert_equal "http://test.host/status/create_statuses", redirect_to_url
    assert_equal @chris.apicalls.first.output_format, flash[:format]
  end

# CREATE APICALL WITH :left_off => true
  test "create apicall with :left_off => true" do  
    # A user checks the "pick up where I left off" checkbox on the new
    # apicall form.                                   
    post :create, { :apicall => @chris.apicalls.second }, 
		  { :user_id => @chris.id }, {}      
    assert_redirected_to create_statuses_url  
    # The app should redirect to status/create_statuses                   
    assert_equal "http://test.host/status/create_statuses", redirect_to_url
    # flash[:format] will tell the status controller whether to proceed 
    # with HTML or RTF.           
    assert_equal @chris.apicalls.second.output_format, flash[:format]
  end

# CAN'T CREATE APICALL WITH BAD PARAMS
  test "can't create apicall with bad params" do
    # 'txt' is not a valid output_format
    invalid_apicall = Apicall.new(:access_token => nil, :user_id => @chris.id, 
                           	  :output_format => "txt", :left_off => true)
    post :create, { :apicall => invalid_apicall }, { :user_id => @chris.id }, {}
    # The app should redirect to the main page.
    assert_redirected_to root_url
    assert_equal "http://test.host/", redirect_to_url
    assert_nil flash[:format] 
  end
end
