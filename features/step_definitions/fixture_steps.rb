require 'fbl/helpers/fixtures'

Given(/^There is a fixture involving (none|one) of the selected teams in the current round of fixtures$/) do |selected_teams|

  date = Date.today.next_day.strftime('%A %d %B %Y')

  @fixtures ||= {}
  @fixtures[date] ||= []
  home_team = selected_teams == 'one' ? Fbl::Fixtures::SELECTED_TEAMS.sample : Fbl::Fixtures::UNSELECTED_TEAMS.sample
  @fixtures[date] << {home_team: home_team, away_team: Fbl::Fixtures::UNSELECTED_TEAMS.sample}

  template = Tilt::ERBTemplate.new File.new 'features/responses/fixtures.html.erb'
  response = template.render(nil, {:fixtures_by_date => @fixtures})

  mirage.put('/en-gb/matchday/matches.html?paramClubId=ALL&paramComp_8=true&view=.dateSeason') do
    body response
    status 200
    http_method :get
  end
end

Then(/^There should be one fixture involving a selected team$/) do

  expect(page.all('.fixtures .fixture').length).to eq(1)
  home_team_image_path = page.find('.fixtures .fixture .home-team')['src']
  away_team_image_path = page.find('.fixtures .fixture .away-team')['src']
  home_team = home_team_image_path.match(/.*\/(.*)\..*/).captures.first
  away_team = away_team_image_path.match(/.*\/(.*)\..*/).captures.first
  is_selected_fixture = Fbl::Fixtures::SELECTED_TEAMS.include?(home_team) || Fbl::Fixtures::SELECTED_TEAMS.include?(away_team)
  expect(is_selected_fixture).to be_true
end

Then(/^I should see the predictions page$/) do
  page.should have_content('Submit your predictions')
end
