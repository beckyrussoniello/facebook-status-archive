Feature: New Archive

	I want to view my old statuses
	As a user
	To reflect on my history via Facebook

Background:
	Given I am a registered user
	And I log in

Scenario: Get all available statuses
	When I click on 'get my statuses'
	Then I should see a list of my statuses

Scenario: Get statuses from the last year
	When I click on 'past year'
	And I click on 'get my statuses'
	Then I should see a list of my statuses
	And every status shown should be from the last year

Scenario: Get statuses from the last two years
	When I click on 'past two years'
	And I click on 'get my statuses'
	Then I should see a list of my statuses
	And every status shown should be from the last two years

@javascript
Scenario: Get statuses from one arbitrary date to another
	When I click on 'more'
	And I select a start date of March 30, 2010
	And I select an end date of January 4, 2011
	And I click on 'get my statuses'
	Then I should see a list of my statuses
	And every status shown should be from between March 30, 2010 and January 4, 2011

Scenario: Rich Text
	When I select 'Rich Text' from the format options
	And I click on 'get my statuses'
	Then an RTF of my statuses should download onto my computer
	And I should be on the homepage 
	# past activity should reflect this new archive