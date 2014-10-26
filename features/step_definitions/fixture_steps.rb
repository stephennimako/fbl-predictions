require 'fbl/helpers/fixtures'

Given(/^There is a fixture involving (none|one|two) of the selected teams in the (current|next) round of fixtures$/) do |number_of_selected_teams, round|
  kick_off = round == 'current' ? Date.today.next_day.strftime('%Y-%m-%d 15:00:00') : Date.today.next_day(3).strftime('%Y-%m-%d 15:00:00')

  teams = case number_of_selected_teams
            when 'one'
              [Fbl::Fixtures::SELECTED_TEAMS.sample, Fbl::Fixtures::UNSELECTED_TEAMS.sample]
            when 'two'
              Fbl::Fixtures::SELECTED_TEAMS.sample 2
            else
              Fbl::Fixtures::UNSELECTED_TEAMS.sample 2
          end

  Fixture.create({kick_off: kick_off, home_team: teams[0], away_team: teams[1]})
end

Then(/^There should be (\d) fixture|fixtures involving a selected team$/) do |selected_fixture_count|
  expect(page.all('.fixtures .fixture').length).to eq(selected_fixture_count.to_i)

  page.all('.fixtures .fixture').each do |fixture_element|

    home_team_image_style = fixture_element.all('.team')[0]['style']
    away_team_image_style = fixture_element.all('.team')[1]['style']

    home_team = home_team_image_style.match(/.*\/(.*)\..*/).captures.first
    away_team = away_team_image_style.match(/.*\/(.*)\..*/).captures.first

    is_selected_fixture = Fbl::Fixtures::SELECTED_TEAMS.include?(home_team) || Fbl::Fixtures::SELECTED_TEAMS.include?(away_team)

    expect(is_selected_fixture).to be_true
  end
end

Then(/^I should see the predictions page$/) do
  page.should have_content('Submit your predictions')
end
