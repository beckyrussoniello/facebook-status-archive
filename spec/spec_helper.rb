require 'simplecov'
SimpleCov.start 'rails'
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

SAMPLE_API_RESPONSE = [{"id"=>"10101477795872089", "from"=>{"name"=>"Becky Russoniello", "id"=>"6831286"}, "message"=>"Thanks so much to everyone who wished me happy birthday!", "updated_time"=>"2012-02-25T02:18:00+0000", "comments"=>{"data"=>[{"id"=>"10101477795872089_15329987", "from"=>{"name"=>"Robbie Arnold", "id"=>"1551420053"}, "message"=>"Anytime Beckels, hope life is treating you well.", "can_remove"=>true, "created_time"=>"2012-02-25T03:36:30+0000", "like_count"=>0, "user_likes"=>false}], "paging"=>{"next"=>"https://graph.facebook.com/10101477795872089/comments?access_token=AAAGgKZBvY5cIBAGgLlEiyqLkITOPFilT8YuqV1keVXID9i8BSWgDVfwAa3Un1iCFTZAuuFV5Trr9TgyarFZBHgGffZB9OxMZD&limit=25&offset=25&__after_id=10101477795872089_15329987"}}}, {"id"=>"10101449720195969", "from"=>{"name"=>"Becky Russoniello", "id"=>"6831286"}, "message"=>"\"I watched that bacon gnome go into my mouth...and then my stomach\" -Chris while asleep", "updated_time"=>"2012-02-17T04:35:39+0000", "likes"=>{"data"=>[{"id"=>"6819697", "name"=>"Riley Martin"}, {"id"=>"100001511612249", "name"=>"Diana Uribe"}, {"id"=>"6848336", "name"=>"Emma Stone"}], "paging"=>{"next"=>"https://graph.facebook.com/10101449720195969/likes?access_token=AAAGgKZBvY5cIBAGgLlEiyqLkITOPFilT8YuqV1keVXID9i8BSWgDVfwAa3Un1iCFTZAuuFV5Trr9TgyarFZBHgGffZB9OxMZD&limit=25&offset=25&__after_id=6848336"}}, "comments"=>{"data"=>[{"id"=>"10101449720195969_15143183", "from"=>{"name"=>"Becky Russoniello", "id"=>"6831286"}, "message"=>"earlier: \"This town looks like it's just a bunch of different waters.\"", "can_remove"=>true, "created_time"=>"2012-02-17T04:36:39+0000", "like_count"=>0, "user_likes"=>false}, {"id"=>"10101449720195969_15143681", "from"=>{"name"=>"James Grahn", "id"=>"1360531978"}, "message"=>"http://www.youtube.com/watch?feature=player_detailpage&v=Tt5lB-RoAi4#t=84s", "can_remove"=>true, "created_time"=>"2012-02-17T05:11:20+0000", "like_count"=>1, "user_likes"=>false}, {"id"=>"10101449720195969_15143712", "from"=>{"name"=>"James Grahn", "id"=>"1360531978"}, "message"=>"Bacon gnome:\nhttp://www.jaysartshop.com/scr-list-products-details.pl?SKU=17631&method=perfect&mytemplate=tp1#", "can_remove"=>true, "created_time"=>"2012-02-17T05:13:04+0000", "like_count"=>2, "user_likes"=>true}, {"id"=>"10101449720195969_15143851", "from"=>{"name"=>"Becky Russoniello", "id"=>"6831286"}, "message"=>"hahaha i guess that just proves that anything you can think of is on the internet!", "can_remove"=>true, "created_time"=>"2012-02-17T05:22:31+0000", "like_count"=>0, "user_likes"=>false}, {"id"=>"10101449720195969_15257350", "from"=>{"name"=>"Laotzu Chris Waggoner", "id"=>"6800805"}, "message"=>"For the record NONE of this had ANYTHING to do with what I was dreaming about!", "can_remove"=>true, "created_time"=>"2012-02-22T07:02:19+0000", "like_count"=>0, "user_likes"=>false}], "paging"=>{"next"=>"https://graph.facebook.com/10101449720195969/comments?access_token=AAAGgKZBvY5cIBAGgLlEiyqLkITOPFilT8YuqV1keVXID9i8BSWgDVfwAa3Un1iCFTZAuuFV5Trr9TgyarFZBHgGffZB9OxMZD&limit=25&offset=25&__after_id=10101449720195969_15257350"}}}]

end
