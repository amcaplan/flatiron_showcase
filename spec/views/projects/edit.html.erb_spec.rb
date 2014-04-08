require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :live_app_url => "MyString",
      :screenshot_path => "MyString",
      :brief_description => "MyString",
      :longer_description => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_path(@project), "post" do
      assert_select "input#project_name[name=?]", "project[name]"
      assert_select "input#project_live_app_url[name=?]", "project[live_app_url]"
      assert_select "input#project_screenshot_path[name=?]", "project[screenshot_path]"
      assert_select "input#project_brief_description[name=?]", "project[brief_description]"
      assert_select "textarea#project_longer_description[name=?]", "project[longer_description]"
    end
  end
end
