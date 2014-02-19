Feature: Attributes of an existing client could be changed
  In order to edit existing users of tour builder
  The admin of the market
  Could edit main attributes of clients and change list of associated tours

Background:
  Given client with name "Hilton" and email address "hilton@example.com" is created

Scenario: Edit main client's attributes
  Given I am logged in as admin
  When I visit the "Clients" tab in admin dashboard
  And the "Clients" tab should be selected
  And I click on the last client in the clients list
  And I should see a page with last client's details
  And last client's details should be ok with email set to "hilton@example.com" and name set to "Hilton"
  When I click on the "Edit Client Info" link
  Then I should be redirected to edit last client's page
  And I change name to "Hilton London" and email address to "hilton_london@example.com"
  When I click on "Save" button
  Then I should see a page with last client's details
  And last client's details should be ok with email set to "hilton_london@example.com" and name set to "Hilton London"
