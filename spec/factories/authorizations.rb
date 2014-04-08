# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    github_uid "MyString"
    repos_url "MyString"
    organizations_url "MyString"
    user nil
  end
end
