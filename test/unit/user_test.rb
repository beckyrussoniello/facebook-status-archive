require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @becky = users(:becky)
    @chris = users(:chris)
    @apicalls = [apicalls(:one), apicalls(:two)]
    @statuses = [statuses(:one), statuses(:two), statuses(:three), statuses(:four)]
  end

# TEST MODEL ASSOCIATIONS
# user has_many :apicalls
  test "has_many :apicalls" do
    assert_equal(3, @chris.apicalls.count)
    assert_equal([2,2,2], @chris.apicalls.collect {|w| w.user_id })
    assert_equal(3, @chris.apicalls.sort_by {|w| w.id }.first.id)

    assert_equal @apicalls, @becky.apicalls
  end

# has_many :statuses
  test "statuses association" do
    assert_equal(6, @chris.statuses.count)
    assert_equal([2,2,2,2,2,2], @chris.statuses.collect {|w| w.user_id })
    assert_equal(5, @chris.statuses.sort_by {|w| w.id }.first.id)

    assert_equal @statuses, @becky.statuses
  end
end
