shared_examples_for "authentication required" do
  it 'responds with redirect to login page' do
    response.status.to_i.should == 302
    response.should redirect_to(new_admin_login_path)
  end
end

shared_examples_for "wrong authentication credentials" do
  it 'responds with login page and alert' do
    response.status.to_i.should == 200
    response.should render_template("admin/login/new")
  end
end
