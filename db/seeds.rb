# Users
User.create!(name:  "Dan SimBed",
             email: "dansimbed@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Amala",
             email: "amala@thespacejuhu.in",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Aadrak",
             email: "aadrak@thespacejuhu.in",
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

#Problems
Problem.create!(name: "Babycakes",
             givengrade: "6c",
             setter: "unknown")

Problem.create!(name: "Excaliboy",
             givengrade: "7a",
             setter: "SimBed")

Problem.create!(name: "Chimpanzee",
             givengrade: "6b+",
             setter: "unknown")

 namearray = []
 # keep number of characters in problem's name below validation maximum
 # keep names of problems unique
 10.times { namearray << Faker::Book.title[0, 25] }
 10.times { namearray << Faker::Movies::LordOfTheRings.character[0, 25] }
 10.times { namearray << Faker::Movies::LordOfTheRings.location[0, 25] }
 10.times { namearray << Faker::Games::WarhammerFantasy.hero[0, 25] }
 namearray.uniq!
 namearray.count.times do |n|
   name  = namearray[n-1]
   givengrade = %w[6a 6b 6c 7a 7b 7c 8a 8b 8c].sample
   setter = "unknown"
   Problem.create!(name: name,
                givengrade: givengrade,
                setter:setter)
 end

#User-Problem Relations

RelUserProblem.create!(user_id: 1,
                  problem_id: 1,
                  suggestedgrade: "7a",
                  highpoint: "CR34",
                  dohp: "4/10/2019",
                  firsttry: "1/10/2019",
                  rating: 2,
                  comment: "nice route")

RelUserProblem.create!(user_id: 1,
                  problem_id: 2,
                  suggestedgrade: "7a",
                  highpoint: "top",
                  dohp: "",
                  firsttry: "",
                  rating: 3,
                  comment: "a Harrow classic")

RelUserProblem.create!(user_id: 1,
                  problem_id: 3,
                  suggestedgrade: "6c+",
                  highpoint: "top",
                  dohp: "28/9/2019",
                  firsttry: "12/4/2019",
                  rating: 2,
                  comment: "cross-through crux")

RelUserProblem.create!(user_id: 2,
                  problem_id: 2,
                  suggestedgrade: "6c+",
                  highpoint: "top",
                  dohp: "",
                  firsttry: "",
                  rating: 2,
                  comment: "didn't match")

RelUserProblem.create!(user_id: 2,
                  problem_id: 1,
                  suggestedgrade: "7a",
                  highpoint: "CR4",
                  dohp: "",
                  firsttry: "",
                  rating: 3,
                  comment: "crap route")

RelUserProblem.create!(user_id: 3,
                  problem_id: 2,
                  suggestedgrade: "7a+",
                  highpoint: "TL1",
                  dohp: "",
                  firsttry: "",
                  rating: 3,
                  comment: "gaston crushed me")


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
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
#users = User.all
#user  = users.first
#following = users[2..50]
#followers = users[3..40]
#following.each { |followed| user.follow(followed) }
#followers.each { |follower| follower.follow(user) }
