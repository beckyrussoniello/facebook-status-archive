Given /^I am a registered user$/ do
		@test_users = Koala::Facebook::TestUsers.new(:app_id => Facebook::APP_ID, :secret => Facebook::SECRET)
		@oauth_token = @test_users.create(true)["access_token"]
		User.create!(:username => "Becky Russoniello", :first_name => "Becky", 
								:last_name => "Russoniello", :fb_id => 6831286, 
								:image_url => "http://graph.facebook.com/6831286/picture?type=square", 
								:oauth_token => @oauth_token)
end

When /^I log in( with Facebook)?$/ do |fb|
	visit '/auth/facebook'
end

When /^I navigate to the app's URL$/ do
	visit '/'
end

Then /^I should be redirected to the Facebook login page$/ do
	page.current_path.should == 'auth/facebook'
end

Then /^I should be redirected to the homepage$/ do
	sleep(5)
	print page.current_path
	page.current_path.should match %r{^\/$|^\/auth\/facebook\/callback$}
end
