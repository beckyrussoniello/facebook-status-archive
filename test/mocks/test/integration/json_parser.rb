require 'lib/json_parser.rb'


=begin
      {
         :id => "162015673822433",
         :from => {
            :name => "Becky Russoniello",
            :id => "6831286"
         },
         :message => "about to watch the series finale of Avatar: The Last Airbender with Laotzu Chris Waggoner.",
         :updated_time => "2010-10-18T05:47:14+0000",
         :comments => {
            :data => [
               {
                  :id => "162015673822433_1739137",
                  :from => {
                     :name => "Joan Russoniello",
                     :id => "1466190284"
                  },
                  :message => "hahahahahahahahahahahaha are you feeling the burn of Zuko's fire-bending heat yet?",
                  :created_time => "2010-10-18T16:32:27+0000"
               },
               {
                  :id => "162015673822433_1749628",
                  :from => {
                     :name => "Becky Russoniello",
                     :id => "6831286"
                  },
                  :message => "haha Zuko is cool",
                  :created_time => "2010-10-19T21:31:11+0000"
               },
               {
                  :id => "162015673822433_1749631",
                  :from => {
                     :name => "Becky Russoniello",
                     :id => "6831286"
                  },
                  :message => "don't be hatin",
                  :created_time => "2010-10-19T21:31:26+0000"
               }
            ]
         }
      },
      {
         :id => "104297359636642",
         :from => {
            :name => "Becky Russoniello",
            :id => "6831286"
         },
         :message => "I wrote my first Facebook app! Recover your status updates with Facebook Status Archive. Check it out at http://archive-fb.com.",
         :updated_time => "2010-10-17T22:26:13+0000",
         :likes => {
            :data => [
               {
                  :id => "6826710",
                  :name => "Kit Westneat"
               }
            ]
         },
         :comments => {
            :data => [
               {
                  :id => "104297359636642_100172",
                  :from => {
                     :name => "Becky Russoniello",
                     :id => "6831286"
                  },
                  :message => "And if you like it...hit \"Like\" on the app!",
                  :created_time => "2010-10-17T22:26:54+0000"
               },
               {
                  :id => "104297359636642_101145",
                  :from => {
                     :name => "Emma Young",
                     :id => "6848336"
                  },
                  :message => "hahaha, this is EXACTLY the app i need, too! it's fun to read through old statuses like they are a journal. good work becky! one comment: it looks like the app is cutting of statuses at a lower character count than FB's--way more of mine are cut off than I think I would have missed at the time, though I guess I can't be positive... but yeah, awesome!",
                  :created_time => "2010-10-18T01:59:00+0000"
               },
               {
                  :id => "104297359636642_101201",
                  :from => {
                     :name => "Becky Russoniello",
                     :id => "6831286"
                  },
                  :message => "haha Emma, I remembered you saying that before...it inspired me!  I also noticed the cut-off issue -- it seems there are certain limitations on the data available via the API.  Another example is that it only goes back to spring/summer 2009.  Unfortunately, there's not much I can do about it :(  At least you'll be able to make sure that no more statuses get erased in the future!",
                  :created_time => "2010-10-18T02:11:53+0000"
               }
            ]
         }
      },
      {
         :id => "139692132744480",
         :from => {
            :name => "Becky Russoniello",
            :id => "6831286"
         },
         :message => "mmmmmmm tea",
         :updated_time => "2010-10-16T17:25:46+0000",
         :likes => {
            :data => [
               {
                  :id => "6848336",
                  :name => "Emma Young"
               }
            ]
         }
      },
      {
         :id => "115322055194790",
         :from => {
            :name => "Becky Russoniello",
            :id => "6831286"
         },
         :message => "10 10 10 10 10!!!  Well, California time, anyway.  Heh.  I missed it here.",
         :updated_time => "2010-10-11T05:10:00+0000",
         :likes => {
            :data => [
               {
                  :id => "23101387",
                  :name => "Rachael Carson"
               }
            ]
         }
      }]
=end

  def JsonParser.get_dataset(access_token, apicall) 
@dataset = [{ :id => "162630990427665", "message" => "New goal: 20/20 in 2020 (I want to get laser eye surgery in the next ten years)", "updated_time" => "2010-10-22T00:40:02+0000"}, { :id => "160103957354260", "message" => "I'm just wearing the same thing I've been wearing for a week.  #purple", "updated_time" => "2010-10-21T00:54:12+0000" }, { :id => "167300903282411", "message" => "my (2-day-old) site is already the 62nd google result for 'archive old facebook statuses' (w/o quotes)!  http://archive-fb.com",
 "updated_time" => "2010-10-20T01:45:38+0000"} ]
    #dataset = @dataset
    return @dataset
  end
