class Archive < ActiveRecord::Base
  attr_accessible :end_date, :output_format_id, :start_date, :user_id

	belongs_to :user
	belongs_to :output_format
	has_many :statuses
	validates_presence_of :output_format_id, :user_id, :start_date, :end_date

	def self.get_dates(params)
		nums = params['archive'].keep_if{|p| p.match(/_date\(/)}
		nums = nums.collect do |param|
			if param[1].empty? 
				/(.*)_date\((\d)i\)/.match(param[0])
				param[1] = case [$1, $2]
					when ['start','1'] then 2011
					when ['end', '1'] then Time.now.year
					when ['end', '2'] then 12
					when ['end', '3'] then 31
					else	1
				end
			else
				param[1] = param[1].to_i
			end
		end
		begin
			[Date.new(nums[0], nums[1], nums[2]), Date.new(nums[3], nums[4], nums[5])]
		rescue ArgumentError
			[2, 5].collect do |n|
				if nums[n] == 31 
					nums[n] = case nums[n-1]
						when 2 then 29
						else 30
					end
				end
			end
			retry
		end
	end

	def create_statuses!
		graph = Koala::Facebook::API.new(self.user.oauth_token)
		collection = graph.get_connections('me', 'statuses')
		statuses = collection
		while statuses.last['updated_time'].to_datetime > user.last_login_at and collection = collection.next_page
			statuses += collection
		end
		statuses.each do |status|
			unless status['message'].nil? or user.statuses.find_by_message(status['message'][0,255])
				Status.create!(message: status['message'][0,255], user_id: user.id, archive_id: self.id, 
										timestamp: status['updated_time'] )
			end
		end
		user.update_attributes!(last_login_at: Time.now)
	end
end
