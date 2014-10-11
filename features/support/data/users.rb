require 'model/user'

Before do
  @user = User.create(username: "user1")
  @user.password = "test1234"
  @user.save
end

After do
  User.destroy_all
end
