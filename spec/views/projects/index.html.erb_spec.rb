require 'spec_helper'

describe "projects/index" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => "Name",
        :live_app_url => "Live App Url",
        :screenshot_path => "Screenshot Path",
        :brief_description => "Brief Description",
        :longer_description => "MyText"
      ),
      stub_model(Project,
        :name => "Name",
        :live_app_url => "Live App Url",
        :screenshot_path => "Screenshot Path",
        :brief_description => "Brief Description",
        :longer_description => "MyText"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Live App Url".to_s, :count => 2
    assert_select "tr>td", :text => "Screenshot Path".to_s, :count => 2
    assert_select "tr>td", :text => "Brief Description".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
