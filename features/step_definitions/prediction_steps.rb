require 'fbl/helpers/fixtures'
include Fbl::Fixtures

When(/^I submit a valid (standard|bonus) prediction$/) do |fixture_type|
  within('.prediction:first-of-type') do
    select(2, :from => 'home-score')
    select(1, :from => 'away-score')

    first('.goal-scorer').select_option
    first('.additional-goal-scorer').select_option if fixture_type == 'bonus'
  end
  click_button('Submit')
end

Then(/^I should (see|not see) a (success|danger) notification$/) do |visible, notification_type|
  expect(page).to have_css(".alert-#{notification_type}") if visible == 'see'
  expect(page).not_to have_css(".alert-#{notification_type}") if visible == 'not see'
end

When(/^I close the (success|danger) notification$/) do |notification_type|
  click_button("close-#{notification_type}")
end

When(/^I submit the same prediction made by another user$/) do
  fixture = Fixture.first

  home_team_score = 2
  away_team_score = 1
  goal_scorer = "#{fixture.home_team} player 0"

  Prediction.create({goal_scorer: goal_scorer, home_team_score: home_team_score, away_team_score: away_team_score, user_id: @user2.id, fixture_id: fixture.id})

  within('.prediction:first-of-type') do
    select(home_team_score, :from => 'home-score')
    select(away_team_score, :from => 'away-score')
    select(goal_scorer, :from => 'goal-scorer')
  end
  click_button('Submit')
end

When(/^user '(.*)' has submitted predictions for this rounds fixtures$/) do |username|
  user = User.create({display_name: username})

  Fixture.where('kick_off > ?', Time.now.strftime("%F %T")).each do |fixture|

    home_team_score = rand(9)
    away_team_score = rand(9)
    home_team = fixture.home_team
    away_team = fixture.away_team
    goal_scorer = "#{home_team} player #{rand(9)}"
    additional_goal_scorer = "#{away_team} player #{rand(9)}" if bonus_fixture?([home_team, away_team])

    prediction_hash = {goal_scorer: goal_scorer, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user.id, fixture_id: fixture.id}
    prediction_hash.merge!(additional_goal_scorer: additional_goal_scorer) if bonus_fixture?([home_team, away_team])
    prediction = Prediction.create(prediction_hash)

    @predictions ||= {}
    @predictions[username] ||= []
    @predictions[username] << prediction
  end
end

Then(/^I should see accordions for each fixture with header '(.*)'$/) do |username|
  @predictions[username].each do |prediction|
    within("#opposition-predictions-#{prediction.id}") do
      expect(page).to have_content(username)
    end
  end
end

Then(/^I should see the score and goal scorers predicted by '(.*)'$/) do |username|
  @predictions[username].each do |prediction|
    fixture = Fixture.find(prediction.fixture_id)
    within("#opposition-predictions-#{prediction.id}") do
      expect(page).to have_content("#{prediction.home_team_score} - #{prediction.away_team_score}")
      expect(page).to have_content(prediction.goal_scorer)
      expect(page).to have_content(prediction.additional_goal_scorer) if Fbl::Fixtures.bonus_fixture? [fixture.home_team, fixture.away_team]
    end
  end
end

When(/^I click on the accordions to see predictions made by '(.*)'$/) do |username|
  @predictions[username].each do |prediction|
    within("#opposition-predictions-#{prediction.id}") do
      click_link(username)
    end
  end
end