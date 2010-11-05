require 'test_helper'

class UsersControllerTest < ActionController::TestCase

# LOGGED IN USER VIEWS PAST ACTIVITY
  test "logged in user views past activity" do
    get :past_activity, {}, { :user_id => users(:chris).id }
    assert_response :success
    assert_template "past_activity"
  end

# LOGGED OUT USER TRIES TO VIEW PAST ACTIVITY
  test "logged out user tries to view past activity" do
    get :past_activity, {}, { :user_id => nil }
    # They should be redirected to the main page.
    assert_redirected_to root_url
  end

# LOGOUT
  test "logout" do
    get :logout, {}, { :user_id => users(:chris).id }
    # After the user logs out, session[:user_id] is nil
    # and the app redirects to the main page.
    assert_nil session[:user_id]
    assert_redirected_to root_url
  end
end
