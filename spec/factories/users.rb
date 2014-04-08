# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    twitter_handle "MyString"
    linkedin_url "MyString"
    github_url "MyString"
    avatar_url "MyString"
    bio "MyText"
    hireable false
  end
end
