When(/^I submit a valid prediction$/) do
  within('.prediction:first-of-type') do
    select(2, :from => 'home-score')
    select(1, :from => 'away-score')
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