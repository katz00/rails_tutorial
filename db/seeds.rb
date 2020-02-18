User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true) #このユーザーを管理者とする。admin属性はデフォルトでnilだから、他のユーザーには明示的に示さなくてもnilになってる

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  
  User.create!(name:  name, email: email,
              password: password,
              password_confirmation: password)
end