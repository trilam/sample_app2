# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
User.create!(name: "Tri Lam", email: "letrilam56@gmail.com", password: "abc123", password_confirmation: "abc123", admin: true,
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Example User", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now)
98.times do |n|
  name=Faker::Name.name
  email="example-#{n+1}@railstutorial.org"
  User.create!(name: name, email: email, password: "password", password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)
end

users= User.order(:created_at).take(6) 

50.times do
  content = Faker::Lorem.sentence(5)
  users.each  { |user| user.microposts.create!(content: content) }
end

users=User.all
me=users.first

users[2..50].each { |my_following| me.follow(my_following) }
users[3..40].each { |my_follower| my_follower.follow(me) }



