require 'fbl/service/fixtures_service'

module Fbl
  module Fixtures
    SELECTED_TEAMS = ['West Ham', 'Chelsea', 'Arsenal', 'Man City', 'Man Utd', 'Liverpool', 'Spurs']
    UNSELECTED_TEAMS = ['Everton', 'Swansea', 'Sunderland', 'Southampton', 'West Brom', 'Newcastle', 'Crystal Palace', 'Burnley', 'Hull', 'Leicester', 'Qpr', 'Aston Villa', 'Stoke']

    def filtered_fixtures
      @fixtures ||= Fbl::Service::FixturesService.new(settings.premier_league_url).current_round
      @fixtures.delete_if do |fixture|
        ([fixture[:home_team], fixture[:away_team]] & SELECTED_TEAMS).empty?
      end
    end
  end
end