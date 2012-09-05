When /^I click on 'get my statuses!'$/ do
	#print page.html
	page.click_button 'get my statuses!'
end

Then /^I should see a list of my statuses$/ do
	sleep(12)
	print page.html
	page.should have_xpath "//span[@class=\"status\"]"
end

When /^I select a start date of (one|two) year(s)? ago today$/ do |num, plural|
	start_date = case num
		when 'one' then 1.year.ago
		else 2.years.ago
	end
	page.select start_date.strftime("%Y"), from: 'archive_start_date_1i'
	page.select start_date.strftime("%B"), from: 'archive_start_date_2i'
	page.select start_date.strftime("%-d"), from: 'archive_start_date_3i'
end

Then /^every status shown should be from the last (two )?year(s)?$/ do |two, plural|
	num = case two
		when 'two ' then 2
		else 1
	end
	page.all("span.timestamp").each do |s|
		s.text.to_datetime.should >= num.years.ago
	end
end

When /^I select a(n)? (end|start) date of (\w+) (\d+), (\d+)$/ do |n, which, month, day, year|
	page.select month, from: "archive_#{which}_date_2i"
	page.select day, from: "archive_#{which}_date_3i"
	page.select year, from: "archive_#{which}_date_1i"
end

Then /^every status shown should be from between (\w+) (\d+), (\d+) and (\w+) (\d+), (\d+)$/ do |m1, d1, y1, m2, d2, y2|
	page.all("span.timestamp").each do |s|
		s.text.to_datetime.should >= Date.new(y1, m1, d1)
		s.text.to_datetime.should <= Date.new(y2, m2, d2)
	end
end

When /^I select 'RTF' from the format options$/ do
	page.select 'RTF', from: 'archive_output_format_id'
end

Then /^an RTF of my statuses should download onto my computer$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be on the homepage$/ do
	page.current_path.should == '/'
end

