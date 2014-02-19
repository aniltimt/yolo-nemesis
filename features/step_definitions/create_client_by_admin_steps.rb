Given /^I am logged in as admin$/ do
  name = 'admin'
  password = '123456'

  visit '/admin'
  if page.driver.respond_to?(:basic_auth)
    page.driver.basic_auth(name, password)
  elsif page.driver.respond_to?(:basic_authorize)
    page.driver.basic_authorize(name, password)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
    page.driver.browser.basic_authorize(name, password)
  else
    raise "I don't know how to log in!"
  end
end

When /^I visit the "([^"]*)" tab in admin dashboard$/ do |tab_name|
  visit "/admin/#{tab_name.downcase}"
end

And /^the "([^"]*)" tab should be selected$/ do |tab_name|
  find('.topbar-inner .container ul.nav').find('li.active').should have_content(tab_name)
end

Then /^I click on the "([^"]*)" link$/ do |link_title|
  click_link link_title
end

Then /^I should see "([^"]*)" dialog$/ do |dialog_name|
  expectation_met = false
  all('.modal .modal-header').each do |el|
    expectation_met = true if el.find('h3').text == dialog_name
  end
  raise RSpec::Expectations::ExpectationNotMetError if ! expectation_met
end

Then /^I insert "([^"]*)" into the "([^"]*)" text input field$/ do |text, field_name|
  fill_in field_name, :with => text 
end

Then /^I click on "([^"]*)" button$/ do |btn_name|
  click_button btn_name
end

Then /^I should see a page with last client's details$/ do
  client = Client.last

  all('.client_info .details .row')[0].all('.span5')[0].should have_content(client.name)
  all('.client_info .details .row')[0].all('.span5')[1].should have_content(client.email)
  all('.client_info .details .row')[1].all('.span5')[0].should have_content(client.password)
  all('.client_info .details .row')[1].all('.span5')[1].should have_content(client.api_key)

  find('a.danger').should have_content("Delete Client")
  find('a.success').should have_content("Edit Client Info")

  page.should have_no_selector('.associated_tours_container')
end

Then /^last client's details should be ok with email set to "([^"]*)" and name set to "([^"]*)"$/ do |email, name|
  client = Client.last
  client.name.should == name
  client.email.should == email
  client.password.should be
  client.api_key.should be
end
