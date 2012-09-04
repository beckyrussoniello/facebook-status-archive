FactoryGirl.define do
  factory :user do
    username 'Becky Russoniello'
		first_name 'Becky'
		last_name 'Russoniello'
		oauth_token 'token123'
		last_login_at { 25.days.ago }
  end
end
