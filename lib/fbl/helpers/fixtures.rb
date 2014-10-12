require 'fbl/service/fixtures_service'

module Fbl
  module Fixtures
    SELECTED_TEAMS = ['Arsenal', 'Chelsea', 'Liverpool', 'Man City', 'Man Utd', 'Spurs', 'West Ham']
    UNSELECTED_TEAMS = ['Aston Villa', 'Burnley', 'Crystal Palace', 'Everton', 'Hull', 'Leicester', 'Newcastle', 'Qpr', 'Southampton', 'Stoke', 'Sunderland', 'Swansea', 'West Brom' ]

    def filtered_fixtures
      @fixtures ||= Fbl::Service::FixturesService.new(settings.premier_league_url).current_round
      @fixtures.delete_if do |fixture|
        ([fixture[:home_team], fixture[:away_team]] & SELECTED_TEAMS).empty?
      end
    end

    def bonus_fixture? teams
      (teams & SELECTED_TEAMS).length == 2
    end
  end
end