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

20.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@hinde.com"
  mobile = "8#{Faker::Number.number(digits: 8)}#{n%10}"
  password = "abba"
  Siteuser.create!(name:  name,
              email: email,
              mobile: mobile,
              password:              password,
              password_confirmation: password,
              freelancer: ([0, 6, 7, 12, 14, 18].include?(n) ? true : false),
              approved:  true,
              activated: true,
              activated_at: Time.zone.now)
end

5.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@khich.com"
  mobile = "8#{Faker::Number.number(digits: 9)}"
  password = "abba"
  Siteuser.create!(name:  name,
              email: email,
              mobile: mobile,
              password:              password,
              password_confirmation: password,
              freelancer: ([2, 4].include?(n) ? true : false))
end

Project.create!(
  title: 'Rails project for banking',
  description: 'Reputed bank wants to develop new website.',
  creating_client_id: 3
)

Project.create!(
  title: 'Encryption software',
  description: 'An encryption system is required to be built for a shopping system.',
  creating_client_id: 7,
  highest_pay: 120,
  payment_currency: 'USD',
  payment_time_unit: 'per hour'
)

Project.create!(
  title: 'Admin Project',
  description: 'Website maintanence.',
  creating_client_id: 1
)

Project.create!(
  title: 'Cloud using eclipse for data storage',
  description: 'Build cloud using eclipse and cloudsim then connect it with SQL server.',
  creating_client_id: 15
)

Bid.create!(
  bidding_user_id: 2,
  project_id: 1,
  description: "Work please!",
  amount: "200"
)

Bid.create!(
  bidding_user_id: 8,
  project_id: 1,
  description: "Work please!",
  amount: "300"
)

Bid.create!(
  bidding_user_id: 2,
  project_id: 2,
  description: "Work please!",
  amount: "50"
)

Bid.create!(
  bidding_user_id: 9,
  project_id: 1,
  description: "Work please!",
  amount: "170"
)