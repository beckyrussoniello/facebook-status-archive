require 'spec_helper'
#FactoryGirl.find_definitions

describe ArchivesController do

	before :each do
		@user = FactoryGirl.create(:user)
		@procky = lambda {post :create, {archive: FactoryGirl.attributes_for(:archive)}, {user_id: @user.id}}
	end

	it 'has a valid factory' do
		FactoryGirl.create(:archive).should be_valid
	end

	describe 'POST #create' do
		it 'calls the model to get start and end dates' do
			Archive.should_receive(:get_dates).and_return [Date.today - 10, Date.today - 1]
			@procky.call
		end

		it 'creates a new instance of Archive' do
			expect{ @procky.call }.to change(Archive, :count).by(1)
		end

		it 'it calls the model to create Status object for each status' do
			Archive.any_instance.should_receive(:create_statuses!)
			@procky.call
		end

		it 'redirects to the show action' do
			@procky.call
			puts params
			response.code.should == '302'
			response.should redirect_to :action => 'show', :id => 1
		end

	end

end
