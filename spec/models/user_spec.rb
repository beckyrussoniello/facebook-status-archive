require 'spec_helper'

describe User do

	before :each do
		@user = FactoryGirl.create(:user)
	end

	describe '#update_token' do
		it 'updates the oauth token' do
			old_token = @user.oauth_token
			@user.update_token('some_token')
			@user.oauth_token.should_not == old_token
			@user.oauth_token.should == 'some_token'
		end
	end


end
