When(/^I log in and visit the predictions page$/) do
  visit '/auth/login'
  fill_in "user[username]", :with => "user1"
  fill_in "user[password]", :with => 'test1234'
  click_button "Log In"
end
Then(/^I should be on the predictions page$/) do
  page.current_path.should == '/'
end