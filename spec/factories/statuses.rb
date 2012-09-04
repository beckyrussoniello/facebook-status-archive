FactoryGirl.define do

	factory :status do
		message "I am so bored."
		timestamp (Date.today - 14)
		archive_id 1	
		user_id 1
	end
end	
