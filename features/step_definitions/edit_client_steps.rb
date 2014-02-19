Given /client with name "([^"]*)" and email address "([^"]*)" is created/ do |name, email|
  Client.create!(:name => name, :email => email)
end

When /^I click on the last client in the clients list$/ do
  rows = all('table#clients_list tbody tr')
  click_link rows.last.all('td')[1].find('a').text
end

Then /^I should be redirected to edit last client's page$/ do
  client = Client.last

  page.has_selector?(:xpath, ".//input[@value=\"#{client.name}\"]")
  page.has_selector?(:xpath, ".//input[@value=\"#{client.email}\"]")
  page.has_selector?(:xpath, ".//input[@value=\"#{client.password}\"]")
  page.has_selector?(:xpath, ".//input[@value=\"#{client.api_key}\"]")
end

Then /^I change name to "([^"]*)" and email address to "([^"]*)"$/ do |new_name, new_email|
  fill_in "user_name", :with => new_name
  fill_in "email_address", :with => new_email
end
