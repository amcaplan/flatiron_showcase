# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_image do
    image "MyString"
    primary_image false
    project nil
  end
end
