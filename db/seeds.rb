# Users
User.create!(name:  "Dan SimBed",
             email: "dansimbed@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "Namrata",
             email: "namrata@thespacejuhu.in",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "Tosh",
             email: "tosh@thespacejuhu.in",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "Kunal",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
             

5.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@thespacejuhu.in"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Microposts
#users = User.order(:created_at).take(6)
#50.times do
  #content = Faker::Lorem.sentence(5)
  #users.each { |user| user.microposts.create!(content: content) }
#end

content = "all my hotpants are in the wash"
User.find(2).microposts.create!(content: content)
content = "where did that item from class go?"
User.find(2).microposts.create!(content: content)
content = "i think i have a crush on my gym constructor"
User.find(3).microposts.create!(content: content)
content = "Why doesn't The Space do memberships?"
User.find(3).microposts.create!(content: content)

users = User.order(:created_at).drop(3)
5.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
#users = User.all
#user  = users.first
#following = users[2..50]
#followers = users[3..40]
#following.each { |followed| user.follow(followed) }
#followers.each { |follower| follower.follow(user) }