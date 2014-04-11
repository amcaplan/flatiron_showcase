# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['developer tools', 'CMS', 'social media', 'the internet of things', 'dashboards', 'food', 'data'].each do |name|
  AppType.create(name: name)
end