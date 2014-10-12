When(/^I submit a valid (standard|bonus) prediction$/) do |fixture_type|
  within('.prediction:first-of-type') do
    select(2, :from => 'home-score')
    select(1, :from => 'away-score')
    select("#{@home_team} player 0", :from => 'goal-scorer')
    select("#{@away_team} player 0", :from => 'additional-goal-scorer') if fixture_type == 'bonus'
  end
  click_button('Submit')
end

Then(/^I should (see|not see) a (success|danger) notification$/) do |visible, notification_type|
  expect(page).to have_css(".alert-#{notification_type}") if visible == 'see'
  expect(page).not_to have_css(".alert-#{notification_type}") if visible == 'not see'
end

When(/^I close the success notification$/) do
  click_button('close-success')
end

When(/^I submit the same prediction made by another user$/) do
  home_team_score = 2
  away_team_score = 1
  goal_scorer = "#{@home_team} player 0"

  Prediction.create({
      home_team: @home_team, away_team: @away_team, kick_off: "#{@date} #{@kick_off_time}",
      goal_scorer: goal_scorer, home_team_score: home_team_score, away_team_score: away_team_score, user_id: @user2.id
                    })
  within('.prediction:first-of-type') do
    select(home_team_score, :from => 'home-score')
    select(away_team_score, :from => 'away-score')
    select(goal_scorer, :from => 'goal-scorer')
  end
  click_button('Submit')
end