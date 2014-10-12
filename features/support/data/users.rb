require 'model/user'

Before do
  User.destroy_all
  @user = User.create(username: "user1", password: "test1234")
  @user2 = User.create(username: "user2", password: "test1234")
end