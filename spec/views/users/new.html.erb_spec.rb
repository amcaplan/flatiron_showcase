require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :name => "MyString",
      :email => "MyString",
      :twitter_handle => "MyString",
      :linkedin_url => "MyString",
      :github_url => "MyString",
      :avatar_url => "MyString",
      :bio => "MyText",
      :hireable => false
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_name[name=?]", "user[name]"
      assert_select "input#user_email[name=?]", "user[email]"
      assert_select "input#user_twitter_handle[name=?]", "user[twitter_handle]"
      assert_select "input#user_linkedin_url[name=?]", "user[linkedin_url]"
      assert_select "input#user_github_url[name=?]", "user[github_url]"
      assert_select "input#user_avatar_url[name=?]", "user[avatar_url]"
      assert_select "textarea#user_bio[name=?]", "user[bio]"
      assert_select "input#user_hireable[name=?]", "user[hireable]"
    end
  end
end
