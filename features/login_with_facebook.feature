Feature: Login with Facebook

	As a user
	I want to login with Facebook
	So that the app can compile my statuses

@javascript
Scenario: New User
	When I navigate to the app's URL
	And I log in with Facebook
	Then I should be redirected to the homepage

@javascript
Scenario: Returning User
	Given I am a registered user
	When I navigate to the app's URL
	And I log in with Facebook
	Then I should be redirected to the homepage
