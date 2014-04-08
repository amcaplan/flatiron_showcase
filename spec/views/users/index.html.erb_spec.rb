require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :twitter_handle => "Twitter Handle",
        :linkedin_url => "Linkedin Url",
        :github_url => "Github Url",
        :avatar_url => "Avatar Url",
        :bio => "MyText",
        :hireable => false
      ),
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :twitter_handle => "Twitter Handle",
        :linkedin_url => "Linkedin Url",
        :github_url => "Github Url",
        :avatar_url => "Avatar Url",
        :bio => "MyText",
        :hireable => false
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Twitter Handle".to_s, :count => 2
    assert_select "tr>td", :text => "Linkedin Url".to_s, :count => 2
    assert_select "tr>td", :text => "Github Url".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
