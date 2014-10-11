require 'spec_helper'
require 'fbl/service/fixtures_service'
require 'webmock/rspec'

describe Fbl::Service::FixturesService do

  base_uri = 'http://localhost:7001/responses'
  let(:subject) { described_class.new(base_uri) }

  context '#current_round' do
    context 'when there is a fixture on day 1 but no other fixture until day 3' do

      before do
        fixtures = {
            Date.today.next_day.strftime('%A %d %B %Y') => [
                {home_team: 'Arsenal', away_team: 'Everton'}],
            Date.today.next_day(3).strftime('%A %d %B %Y') => [
                {home_team: 'Chelsea', away_team: 'Stoke'}]}
        stub_fixtures_request base_uri, fixtures
      end

      it 'returns fixture for day 1' do
        expect(subject.current_round).to eq([
                                                {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00",
                                                 home_team: 'Arsenal', away_team: 'Everton'}])
      end
    end

    context 'when there is a fixture on day 1 and day 2 but no fixture other fixture until day 4' do
      before do
        fixtures = {
            Date.today.next_day.strftime('%A %d %B %Y') => [
                {home_team: 'Arsenal', away_team: 'Everton'}
            ],
            Date.today.next_day(2).strftime('%A %d %B %Y') => [
                {home_team: 'Chelsea', away_team: 'Stoke'}
            ],
            Date.today.next_day(4).strftime('%A %d %B %Y') => [
                {home_team: 'Hull', away_team: 'Spurs'}
            ]}

        stub_fixtures_request base_uri, fixtures
      end

      it 'returns fixtures for day 1 and 2' do
        expect(subject.current_round).to eq(
                                             [
                                                 {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
                                                 {kick_off: "#{Date.today.next_day(2).strftime('%A %d %B %Y')} 15:00:00", home_team: 'Chelsea', away_team: 'Stoke'}
                                             ])
      end
    end

    context 'when there are multiple fixtures on day 1' do
      before do
        fixtures = {
            Date.today.next_day.strftime('%A %d %B %Y') => [
                {home_team: 'Arsenal', away_team: 'Everton'},
                {home_team: 'Chelsea', away_team: 'Stoke'},
                {home_team: 'Spurs', away_team: 'Hull'}
            ]}
        stub_fixtures_request base_uri, fixtures
      end

      it 'return all fixtures from day 1' do
        expect(subject.current_round).to eq([
                                                {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
                                                {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Chelsea', away_team: "Stoke"},
                                                {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Spurs', away_team: 'Hull'}
                                            ])
      end
    end

    context 'when no fixtures in future' do
      before do
        stub_fixtures_request base_uri, {}
      end

      it 'returns no fixtures' do
        expect(subject.current_round).to eq([])
      end

    end
  end

  context '#next_fixture_date_not_in_current_round' do
    context
  end

  def stub_fixtures_request base_uri, fixtures
    template = Tilt::ERBTemplate.new File.new 'features/responses/fixtures.html.erb'
    response = template.render(nil, {:fixtures_by_date => fixtures})
    stub_request(:get, "#{base_uri}/en-gb/matchday/matches.html?paramClubId=ALL&paramComp_8=true&view=.dateSeason").to_return(status: 200, body: response)
  end

end