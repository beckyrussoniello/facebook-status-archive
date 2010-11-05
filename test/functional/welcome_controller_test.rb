require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
fixtures :all

# GET INDEX WITHOUT USER
  test "get index without user" do
    get :index, {}, { }
    assert_response :success
    # Should display the _logged_out_index, which contains a 
    # description of the app.
    assert_select "section#app_description"
  end

# GET INDEX WITH LOGGED IN FIRST-TIME USER
  test "get index with logged in first-time user" do
    get :index, {}, { :user_id => users(:new_person).id }
    assert_response :success
    # Should display the _logged_in_index.  Since this user 
    # is new, it contains a description of the app (rather
    # than past activity) and the new apicall form.
    assert_select "section#app_description"
    assert_select "section.form"
  end

# GET INDEX WITH LOGGED IN RETURNING USER
  test "get index with logged in returning user" do
    get :index, {}, { :user_id => users(:chris).id }
    assert_response :success
    # Should display the _logged_in_index.  Since this is a
    # returning user, the page displays their past activity
    # along with the new apicall form.
    assert_select "section.past_activity"
    assert_select "section.form"
  end


end
