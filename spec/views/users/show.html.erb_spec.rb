require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Name",
      :email => "Email",
      :twitter_handle => "Twitter Handle",
      :linkedin_url => "Linkedin Url",
      :github_url => "Github Url",
      :avatar_url => "Avatar Url",
      :bio => "MyText",
      :hireable => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Twitter Handle/)
    rendered.should match(/Linkedin Url/)
    rendered.should match(/Github Url/)
    rendered.should match(/Avatar Url/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
  end
end
