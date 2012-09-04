class WelcomeController < ApplicationController
  def index
		@archive = Archive.new
		@output_formats = OutputFormat.all
		render do |format|
			format.html {}
			format.js {}
		end
  end

  def login
		redirect_to 'auth/facebook' if @auth = request.env["omniauth.auth"].nil?
		@auth = request.env["omniauth.auth"].to_hash
		unless @user = User.find_by_fb_id(@auth['uid'].to_i)
			@user = User.create!(username: @auth['info']['name'], first_name: @auth['info']['first_name'],
														last_name: @auth['info']['last_name'], fb_id: @auth['uid'],
														last_login_at: APP_START_DATE, image_url: @auth['info']['image'], 
														oauth_token: @auth['credentials']['token'])
		end
		session[:user_id] = @user.id
		@user.update_token(@auth['credentials']['token'])
		redirect_to action: 'index'
  end
end
