Then /^I should see a list with (\d+) entry of (\d+) generated users associated with "([^"]*)"$/ do |num_of_entries, users_count, client_name|
  client = Client.find_by_name client_name
  client.users.count.should == users_count.to_i
  all('#associated_users_container table tr').size.should == num_of_entries.to_i
  all('#associated_users_container table tr td')[1].text.to_i.should == users_count.to_i
end

Then /^I should successfully log in into market as any of the recently generated hidden users for "([^"]*)"$/ do |client_name|
  visit '/users/sign_in'
  client = Client.find_by_name client_name
  hidden_user = client.users.last
  fill_in "user_email", :with => hidden_user.email
  fill_in "user_password", :with => hidden_user.name
  click_button "Sign in"
  page.html.should match hidden_user.reload.authentication_token
end
