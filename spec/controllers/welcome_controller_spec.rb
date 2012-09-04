require 'spec_helper'

describe WelcomeController do

	before :each do
		@user = FactoryGirl.create(:user)
	end

	describe 'GET #index' do
		context 'logged-in user' do
			before :each do
			 	get :index, {}, {user_id: @user.id}
			end

			it 'renders the index view, rather than redirecting' do
				response.code.should == '200'
				response.should render_template 'index'
			end
		end

		context 'user not logged in yet' do
			before :each do
				get :index
			end

			it 'redirects to auth/facebook' do
				response.code.should == '302'
				response.should redirect_to '/auth/facebook'
			end
		end
	end

	describe 'login' do

		before :each do
			@auth_hash = YAML.load_file(Rails.root.join("spec/fixtures/fake_omniauth_hash.yml"))
			@procky = lambda {request.env["omniauth.auth"] = @auth_hash
								get :login, :provider => 'facebook'} #'/auth/facebook/callback'
		end

		it 'assigns facebook data to hash called @auth' do
			@procky.call
			assigns(:auth).should_not be_nil
			assigns(:auth).should be_a Hash
			assigns(:auth).should have_key 'uid'
		end

		it 'tries to find an existing user by fb_id' do
			User.should_receive(:method_missing).with(:find_by_fb_id, @auth_hash['uid'].to_i)
			@procky.call
		end

		context 'first-time user' do

			it 'creates a new user with the omniauth hash' do
				#time = Time.now
				#Timecop.freeze(time)
				User.should_receive(:create!).with(username: @auth_hash['info']['name'], 
														first_name: @auth_hash['info']['first_name'], 
														last_name: @auth_hash['info']['last_name'], 
														fb_id: @auth_hash['uid'], last_login_at: APP_START_DATE, 
														image_url: @auth_hash['info']['image'],
														oauth_token: @auth_hash['credentials']['token'])
															.and_return(FactoryGirl.create(:user))
				@procky.call
			#	Timecop.return
			end

			it 'assigns @user to the newly-created user' do
				@procky.call
				assigns(:user).should_not be_nil
				assigns(:user).should be_an_instance_of User
				assigns(:user).id.should_not be_nil
			end

		end

		context 'user already exists' do

			it 'does not create a new user' do
				@user = FactoryGirl.build(:user, :fb_id => @auth_hash['uid'])
				@user.save!
				User.should_not_receive(:create!)
				@procky.call
			end

		end

		it 'sets session[:user_id]' do
			@procky.call
			session[:user_id].should_not be_nil
			session[:user_id].should == User.find_by_fb_id(@auth_hash['uid']).id
		end

		it 'records the login' do
			User.any_instance.should_receive(:record_login)
			@procky.call
		end

		it 'redirects to index' do
			@procky.call
			response.code.should == '302'
			response.should redirect_to :action => 'index'
		end
	end
end
