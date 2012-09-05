@javascript
Feature: New Archive

	I want to view my old statuses
	As a user
	To reflect on my history via Facebook

Background:
	Given the following output formats exist:
	|name|
	|HTML|
	|RTF |
	And I am a registered user
	And I log in

Scenario: Get all available statuses
	When I click on 'get my statuses!'
	Then I should see a list of my statuses

Scenario: Get statuses from the last year
	When I select a start date of one year ago today
	And I click on 'get my statuses!'
	Then I should see a list of my statuses
	And every status shown should be from the last year

Scenario: Get statuses from one arbitrary date to another
	When I select a start date of March 30, 2011
	And I select an end date of January 4, 2012
	And I click on 'get my statuses!'
	Then I should see a list of my statuses
	And every status shown should be from between March 30, 2010 and January 4, 2011

Scenario: Rich Text
	When I select 'RTF' from the format options
	And I click on 'get my statuses!'
	Then an RTF of my statuses should download onto my computer
	And I should be on the homepage 
