# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Siteuser.create!(
  name:  "Debanjan Dey",
  email: "debanjandey64@gmail.com",
  password: "abbajabba",
  password_confirmation: "abbajabba",
  admin:     true,
  approved:  true,
  activated: true,
  activated_at: Time.zone.now
)

10.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@hinde.com"
  mobile = "8#{Faker::Number.number(digits: 8)}#{n}"
  password = "abba"
  Siteuser.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              approved:  true,
              activated: true,
              activated_at: Time.zone.now)
end

15.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@khich.com"
  mobile = "8#{Faker::Number.number(digits: 9)}"
  password = "abba"
  Siteuser.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password)
end