FactoryGirl.define do

	factory :archive do
		output_format_id 1
		start_date (Date.today-60)	
		end_date Date.today
		user_id 1
	end
end	
