class WelcomeController < ApplicationController

# INDEX
  def index
    # LOCAL VERSION ONLY!!
      session[:user_id] = 1
    if session[:user_id]
      @user = User.find(session[:user_id])
      @apicall = Apicall.new
    end
    if current_facebook_user
      current_facebook_user.fetch
      @user = User.find(session[:user_id])
      @apicall = Apicall.new
    end
  end
end
