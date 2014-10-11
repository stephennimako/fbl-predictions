When(/^I submit a valid (standard|bonus) prediction$/) do |fixture_type|
  within('.prediction:first-of-type') do
    select(2, :from => 'home-score')
    select(1, :from => 'away-score')
    select("#{@home_team} player 0", :from => 'goal-scorer')
    select("#{@away_team} player 0", :from => 'additional-goal-scorer') if fixture_type == 'bonus'
  end
  click_button('Submit')
end

Then(/^I should (see|not see) a success notification$/) do |visible|
  expect(page).to have_css('.alert-success') if visible == 'see'
  expect(page).not_to have_css('.alert-success') if visible == 'not see'
end
When(/^I close the success notification$/) do
  click_button('close-success')
end