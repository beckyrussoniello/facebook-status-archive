class User < ActiveRecord::Base
  attr_accessible :fb_id, :first_name, :image_url, :last_login_at,
									:last_name, :oauth_secret, :oauth_token, :username

	has_many :archives
	has_many :statuses

	def update_token(new_token)
		self.update_attributes!(:oauth_token => new_token)
	end
end
