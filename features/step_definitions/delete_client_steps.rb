When /^I click on the "([^"]*)" in the clients list$/ do |client_name|
  within "#clients_list" do
    click_link client_name
  end
end

When /^I should see a page with "([^"]*)" details$/ do |arg1|
  client = Client.find_by_name "Hyatt"
  all('.client_info .details .row')[0].all('.span5')[0].should have_content(client.name)
  all('.client_info .details .row')[0].all('.span5')[1].should have_content(client.email)
  all('.client_info .details .row')[1].all('.span5')[0].should have_content(client.password)
  all('.client_info .details .row')[1].all('.span5')[1].should have_content(client.api_key)
end

Then /^I should see a list of clients with only "([^"]*)" client left$/ do |client_name|
  rows = all('table#clients_list tbody tr')
  Rails.logger.warn 'rows = ' + rows.inspect
  rows.length.should == 1
  rows.first.all('td')[1].find('a').text.should == client_name
end

Then /^I should see "([^"]*)" notice$/ do |notice|
  find('.alert-message.success').should have_content(notice)
end

Then /^I click on "Delete Client" link for "([^"]*)" client$/ do |client_name|
  rack_test_session_wrapper = Capybara.current_session.driver
  client = Client.find_by_name client_name
  rack_test_session_wrapper.delete admin_client_path(client.id)
end
