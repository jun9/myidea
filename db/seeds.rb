# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
owner = User.create(:username => "admin",:email => "admin@example.com",:password =>"123456",:password_confirmation => "123456")
owner.admin = true
owner.owner = true
owner.save
