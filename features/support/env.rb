Bundler.require :test

require 'capybara/cucumber'
require 'fbl/app'

Capybara.app = Fbl::App

Before do
  @user = Fbl::User.create(username: "user1")
  @user.password = "test1234"
  @user.save
end

After do
  Fbl::User.destroy
end





