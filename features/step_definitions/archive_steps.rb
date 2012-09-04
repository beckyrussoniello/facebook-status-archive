When /^I click on 'get my statuses'$/ do
	page.click_button 'get my statuses'
end

Then /^I should see a list of my statuses$/ do
	page.should have_xpath "//div[@id=\"statuses\"]"
end

When /^I click on 'past year'$/ do
	page.click_link 'past year'
end

Then /^every status shown should be from the last year$/ do
	page.all("div.status").each do |s|
		status = Status.find_by_fb_id() # FIX THIS!!
	end
end

When /^I click on 'past two years'$/ do
	page.click_link 'past two years'
end

Then /^every status shown should be from the last two years$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I click on 'more'$/ do
	page.click_link 'more'
end

When /^I select a start date of (\w+) (\d+), (\d+)$/ do |month, day, year|
	page.select month, from: 'Month'
	page.select day, from: 'Day'
	page.select year, from: 'Year'
end

When /^I select an end date of (\w+) (\d+), (\d+)$/ do |month, day, year|
  pending # express the regexp above with the code you wish you had
end

Then /^every status shown should be from between (\w+) (\d+), (\d+) and (\w+) (\d+), (\d+)$/ do |m1, d1, y1, m2, d2, y2|
  pending # express the regexp above with the code you wish you had
end

When /^I select 'Rich Text' from the format options$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^an RTF of my statuses should download onto my computer$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be on the homepage$/ do
	page.current_path.should == '/'
end

