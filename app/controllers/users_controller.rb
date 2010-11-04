class UsersController < ApplicationController

  before_filter :authorize, :only => [:logout]

# POST CALLBACK
  def post_callback
    fbs = cookies["fbs_#{Facebooker2.app_id}"] 
       # Remove leading and trailing \" 
       fbs.slice!(0) 
       fbs.slice!(fbs.length - 1)
       fb_params_after_permissions = Rack::Utils.parse_query(fbs) 
      # Get the user's info from Facebook.
      current_facebook_user.fetch 
  
     # Determine whether user has used the app before.
     previous_user = User.find_by_fb_id(current_facebook_user[:id])
     unless @user = previous_user
       # If not, create a new User model instance with 
       # the user's Facebook info.
       @user = User.create!(:name => current_facebook_user[:name], 
			    :first_name => current_facebook_user[:first_name],
                            :last_name => current_facebook_user[:last_name], 
			    :fb_id => current_facebook_user[:id])
     end
      # Set the session[:user_id] and session[:token]
     session[:user_id] = @user.id 
     session[:token] = fb_params_after_permissions["access_token"]
     redirect_to root_url
  end

# POST CALLBACK MOCK
 def post_callback_mock
    # This is a mock version of the post_callback action
    # above.  It is used for testing only.
    @current_fb_user = params[:current_fb_user]
    previous_user = User.find_by_fb_id(params[:current_fb_user][:id])
    unless @user = previous_user
      @user = User.create!(:name => params[:current_fb_user][:name], 
			   :first_name => params[:current_fb_user][:first_name],
                           :last_name => params[:current_fb_user][:last_name], 
			   :fb_id => params[:current_fb_user][:id])
    end

        session[:user_id] = @user.id
        session[:token] = "thisistheaccesstoken"
       redirect_to root_url
 end

# PAST ACTIVITY
  def past_activity
    # User must be logged in to view past activity.
    @user = User.find(session[:user_id])
    # If not logged in, they will be redircted to
    # the main page.
    rescue
      redirect_to root_url
  end

# LOGOUT
  def logout
    session[:user_id] = nil
    session[:token] = nil
    redirect_to root_url
  end
end
