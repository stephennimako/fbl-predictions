When(/^I log in and visit the predictions page$/) do
  visit '/auth/login'
  fill_in "user[username]", :with => "user1"
  fill_in "user[password]", :with => 'test1234'
  click_button "Log In"
end