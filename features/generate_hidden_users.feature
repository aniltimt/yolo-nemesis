Feature: Admin should create hidden users of tours market associated with specific client

Background:
  Given client with name "Hilton" and email address "hilton@example.com" is created
  And client with name "Hyatt" and email address "hyatt@example.com" is created

Scenario: Market admin creates a hidden users associated with specific client
  Given I am logged in as admin
  When I visit the "Clients" tab in admin dashboard
  And the "Clients" tab should be selected

  And I click on the "Hyatt" in the clients list
  And I should see a page with "Hyatt" details
  When I click on the "Generate Users" link
  Then I should see "Hyatt: Generate Users" dialog
  And I insert "10" into the "Quantity" text input field
  And I click on "Generate" button
  Then I should see a list with 1 entry of 10 generated users associated with "Hyatt"
  And I should successfully log in into market as any of the recently generated hidden users for "Hyatt"
