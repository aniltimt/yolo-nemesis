Feature: An existing client with 0 tours could be deleted
  The admin of the market
  Could delete clients only with 0 associated tours

Background:
  Given client with name "Hilton" and email address "hilton@example.com" is created
  And client with name "Hyatt" and email address "hyatt@example.com" is created

Scenario: Edit main client's attributes
  Given I am logged in as admin
  When I visit the "Clients" tab in admin dashboard
  And I click on the "Hyatt" in the clients list
  And I should see a page with "Hyatt" details
  #When I click on the "Delete Client" link
  #Then I should see "Delete Client?" dialog
  #And I click on "Delete Client" link for "Hyatt" client
  #When I visit the "Clients" tab in admin dashboard
  #Then I should see a list of clients with only "Hilton" client left
  #And I should see "The client 'Hyatt' was successfully deleted" notice
