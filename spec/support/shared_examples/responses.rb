shared_examples_for "OK response" do
  it 'responds with 200' do
    response.status.to_i.should == 200
  end
end

shared_examples_for "redirect response" do
  it 'responds with 302' do
    response.status.to_i.should == 302
  end
end
