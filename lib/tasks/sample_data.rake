namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar")
                 
    30.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password)
    end
  end
  
  task scoredata: :environment do
    10.times do |n|
      user_id  = n + 1
      store_id  = 1
      model = "海物語"
      seat  = 1234
      time = Time.now
      investment = 1000 + 800 * n
      proceeds = 5000 - 1000 * n
      Score.create!(user_id: user_id,
                   store_id: store_id,
                   model: model,
                   seat: seat,
                   start_at: time,
                   end_at: time + 3600,
                   investment: investment,
                   proceeds: proceeds)
    end
    10.times do |n|
      user_id  = n + 1
      store_id  = 2
      model = "バジリスク絆"
      seat  = 1234
      time = Time.now
      investment = 1000 + 500 * n
      proceeds = 7000 - 1500 * n
      Score.create!(user_id: user_id,
                   store_id: store_id,
                   model: model,
                   seat: seat,
                   start_at: time,
                   end_at: time + 36000,
                   investment: investment,
                   proceeds: proceeds)
    end
  end
end
