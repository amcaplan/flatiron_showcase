require 'spec_helper'

describe "projects/show" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :live_app_url => "Live App Url",
      :screenshot_path => "Screenshot Path",
      :brief_description => "Brief Description",
      :longer_description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Live App Url/)
    rendered.should match(/Screenshot Path/)
    rendered.should match(/Brief Description/)
    rendered.should match(/MyText/)
  end
end
