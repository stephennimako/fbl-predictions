When(/^I submit a valid prediction$/) do
  within('.prediction') do
    select(2, :from => 'home-score')
    select(1, :from => 'away-score')
    select('Wayne Rooney', :from => 'goal-scorer')
    click_button('submit')
  end
end

Then(/^I should see a success notification$/) do
  pending
end
