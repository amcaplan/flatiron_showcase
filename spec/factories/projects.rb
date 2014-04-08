# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "MyString"
    live_app_url "MyString"
    screenshot_path "MyString"
    brief_description "MyString"
    longer_description "MyText"
  end
end
