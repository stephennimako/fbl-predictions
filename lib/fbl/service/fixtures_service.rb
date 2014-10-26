require 'model/fixture'

module Fbl
  module Service
    class FixturesService

      def initialize base_uri
        @base_uri = base_uri
      end

      def current_round
        fixtures = current_fixtures
        if fixtures.length == 0
          Fixture.create(retrieve_new_fixtures)
        end
        current_fixtures.map { |fixture| fixture.as_json.slice('home_team', 'away_team', 'kick_off').symbolize_keys }
      end

      def retrieve_new_fixtures
        page = Nokogiri::HTML(Faraday.get("#{@base_uri}/en-gb/matchday/matches.html?paramClubId=ALL&paramComp_8=true&view=.dateSeason").body)

        fixtures = []
        current_fixture_date = nil
        page.css('.fixturelist .contentTable').each do |fixtures_table|
          fixture_date = fixtures_table.css('tr')[0].css('th').text

          next_fixture_date = DateTime.parse(fixture_date)
          break if current_fixture_date != nil && next_fixture_date - current_fixture_date > 1
          current_fixture_date = next_fixture_date

          fixtures_table.css('tr').each do |fixture|
            teams = fixture.css('td.clubs a').text
            if teams == ""
              next
            else
              teams_split = teams.split(' v ')
              home_team = teams_split[0].strip
              away_team = teams_split[1].strip
              time = fixture.css('td.time').text
              kick_off = fixture_date + time + ':00'
              current_fixture_date = DateTime.parse(kick_off)

              fixtures << {:kick_off => kick_off, :home_team => home_team, :away_team => away_team}
            end
          end
        end
        fixtures
      end

      def current_fixtures
        Fixture.where('kick_off > ?', Time.now.strftime("%F %T"))
      end

    end
  end
end