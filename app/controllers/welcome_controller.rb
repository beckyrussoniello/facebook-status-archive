class WelcomeController < ApplicationController

# INDEX
  def index
    if current_facebook_user
      current_facebook_user.fetch
      @user = User.find(session[:user_id])
      @apicall = Apicall.new
    end
  end
end
