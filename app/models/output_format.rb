class OutputFormat < ActiveRecord::Base
  attr_accessible :name

	has_many :archives
end
