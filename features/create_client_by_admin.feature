Feature: Client should be created by admin only
  In order to create new users of tour builder
  The admin of the market
  Should generate new client

Scenario: Market admin creates a client
  Given I am logged in as admin
  When I visit the "Clients" tab in admin dashboard
  And the "Clients" tab should be selected
  And I click on the "Add Client" link
  Then I should see "Add Client" dialog
  Then I insert "Hilton" into the "user_name" text input field
  And I insert "hilton@example.com" into the "email_address" text input field
  And I click on "Create client" button
  And I should see a page with last client's details
  And last client's details should be ok with email set to "hilton@example.com" and name set to "Hilton"
