# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
include ApplicationHelper

all_skills = get_all_skill

dd = Siteuser.create!(
  name:  "Debanjan Dey",
  email: "debanjandey64@gmail.com",
  password: "admin",
  password_confirmation: "admin",
  admin:     true,
  approved:  true,
  activated: true,
  activated_at: Time.zone.now,
  skills: all_skills[0..8] + [all_skills[16], all_skills[19]]
)
dd.profile_pic.attach(io: File.open(Rails.root.join('app', 'assets', 'images', '56939.jpg')), filename: '56939.jpg', content_type: 'image/jpg')

20.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@hinde.com"
  mobile = "8#{Faker::Number.number(digits: 8)}#{n%10}"
  password = "abba"
  u1 = Siteuser.create!(name:  name,
              email: email,
              mobile: mobile,
              password:              password,
              password_confirmation: password,
              freelancer: ([0, 6, 7, 12, 14, 18].include?(n) ? true : false),
              approved:  true,
              activated: true,
              activated_at: Time.zone.now,
              skills: all_skills.sample(8))
  u1.profile_pic.attach(io: File.open(Rails.root.join('app', 'assets', 'images', '56939.jpg')), filename: '56939.jpg', content_type: 'image/jpg')
end

15.times do |n|
  name  = Faker::Name.name
  email = "u#{n+1}@khich.com"
  mobile = "8#{Faker::Number.number(digits: 9)}"
  password = "abba"
  u2 = Siteuser.create!(name:  name,
              email: email,
              mobile: mobile,
              password:              password,
              password_confirmation: password,
              freelancer: true,
              skills: all_skills.sample(6))
  u2.profile_pic.attach(io: File.open(Rails.root.join('app', 'assets', 'images', '56939.jpg')), filename: '56939.jpg', content_type: 'image/jpg')
end

skills1 = all_skills[4..7] + [all_skills[15]]
skills2 = all_skills[0..3] + [all_skills[20]]
skills3 = all_skills[4..7] + [all_skills[11], all_skills[22]]
skills4 = [all_skills[2], all_skills[21], all_skills[22]]

Project.create!(
  creating_client_id: 3,
  title: 'Rails project for banking',
  description: 'Reputed bank wants to develop new website.',
  payment_currency: 'INR',
  highest_pay: 25000,
  payment_time_unit: '(onetime)',
  skills: skills1
)

Project.create!(
  title: 'Encryption software',
  description: 'An encryption system is required to be built for a shopping system.',
  creating_client_id: 7,
  highest_pay: 120,
  payment_currency: 'USD',
  payment_time_unit: 'per hour',
  skills: skills2
)

Project.create!(
  title: 'Admin Project',
  description: 'Website maintanence.',
  creating_client_id: 3,
  payment_currency: 'INR',
  highest_pay: 250,
  payment_time_unit: 'per day',
  skills: skills3
)

Project.create!(
  title: 'Cloud using eclipse for data storage',
  description: 'Build cloud using eclipse and cloudsim then connect it with SQL server.',
  creating_client_id: 15,
  payment_currency: 'INR',
  highest_pay: 120,
  payment_time_unit: 'per day',
  skills: skills4
)

bidder_list_1 = Siteuser.freelancers.active.select { |u| u.skills & skills1 != [] }
bidder_list_2 = Siteuser.freelancers.active.select { |u| u.skills & skills2 != [] }

Bid.create!(
  bidding_user_id: bidder_list_1[0].id,
  project_id: 1,
  description: "Work please!",
  amount: "20000"
)

Bid.create!(
  bidding_user_id: bidder_list_1[1].id,
  project_id: 1,
  description: "Work please!",
  amount: "15000"
)

Bid.create!(
  bidding_user_id: bidder_list_2[0].id,
  project_id: 2,
  description: "Work please!",
  amount: "105"
)

Bid.create!(
  bidding_user_id: bidder_list_1[2].id,
  project_id: 1,
  description: "Work please!",
  amount: "17000"
)