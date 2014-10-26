require 'spec_helper'
require 'fbl/service/fixtures_service'
require 'webmock/rspec'

describe Fbl::Service::FixturesService do
  include_context :database

  before do
    Fixture.destroy_all
  end

  base_uri = 'http://localhost:7001/responses'
  let(:subject) { described_class.new(base_uri) }
  let(:fixtures) do
    [
        {kick_off: "#{Date.today.next_day.strftime('%Y-%m-%d')} 15:00:00",
         home_team: 'Arsenal', away_team: 'Everton'}
    ]
  end

  context '#current_round' do
    context 'latest fixtures have been downloaded' do
      before do
        @created_fixtures = Fixture.create(fixtures)
      end

      it 'should return fixtures' do
        expected_fixtures = @created_fixtures.map { |fixture| fixture.as_json.slice('home_team', 'away_team', 'kick_off').symbolize_keys }
        expect(subject.current_round).to eq(expected_fixtures)
      end
    end

    context 'latest fixtures have not been downloaded' do

      before do
        allow(subject).to receive(:retrieve_new_fixtures).and_return(fixtures)
      end

      it 'should save fixtures' do
        subject.current_round
        expect(Fixture.where(fixtures.first).length).to eq(1)
      end
    end
  end

  context '#current_fixtures' do

    before do
      Timecop.freeze(Time.local(2014, 10, 24, 14, 59, 59))
      Fixture.create([
                         {kick_off: "2014-10-24 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
                         {kick_off: "2014-10-24 15:59:00", home_team: 'Chelsea', away_team: "Stoke"},
                         {kick_off: "2014-10-23 15:00:00", home_team: 'Leicester', away_team: 'Hull'},
                         {kick_off: "2014-10-24 14:59:59", home_team: 'Everton', away_team: 'Hull'},
                         {kick_off: "2014-10-24 16:00:00", home_team: 'Crystal Palace', away_team: 'Leicester'},
                         {kick_off: "2014-10-24 15:00:00", home_team: 'Spurs', away_team: 'Everton'}
                     ])
    end

    after do
      Timecop.return
    end

    it 'should retrieve fixtures from db' do
      expect(subject.current_fixtures.length).to eq(4)
    end
  end

  context '#retrieve_new_fixtures' do
    context 'when there is a fixture on day 1 but no other fixture until day 3' do

      before do
        stub_fixtures = {
            Date.today.next_day.strftime('%Y-%m-%d') => [
                {home_team: 'Arsenal', away_team: 'Everton'}],
            Date.today.next_day(3).strftime('%Y-%m-%d') => [
                {home_team: 'Chelsea', away_team: 'Stoke'}]}
        stub_fixtures_request base_uri, stub_fixtures
      end

      it 'returns fixture for day 1' do
        expect(subject.retrieve_new_fixtures).to eq(fixtures)
      end
    end

    context 'when there is a fixture on day 1 and day 2 but no fixture other fixture until day 4' do
      let(:fixtures) do
        [
            {kick_off: "#{Date.today.next_day.strftime('%Y-%m-%d')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
            {kick_off: "#{Date.today.next_day(2).strftime('%Y-%m-%d')} 15:00:00", home_team: 'Chelsea', away_team: 'Stoke'}
        ]
      end

      before do
        stub_fixtures = {
            Date.today.next_day.strftime('%Y-%m-%d') => [
                {home_team: 'Arsenal', away_team: 'Everton'}
            ],
            Date.today.next_day(2).strftime('%Y-%m-%d') => [
                {home_team: 'Chelsea', away_team: 'Stoke'}
            ],
            Date.today.next_day(4).strftime('%Y-%m-%d') => [
                {home_team: 'Hull', away_team: 'Spurs'}
            ]}

        stub_fixtures_request base_uri, stub_fixtures
      end

      it 'returns fixtures for day 1 and 2' do
        expect(subject.retrieve_new_fixtures).to eq(fixtures)
      end
    end

    context 'when there are multiple fixtures on day 1' do
      let(:fixtures) do
        [
            {kick_off: "#{Date.today.next_day.strftime('%Y-%m-%d')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
            {kick_off: "#{Date.today.next_day.strftime('%Y-%m-%d')} 15:00:00", home_team: 'Chelsea', away_team: "Stoke"},
            {kick_off: "#{Date.today.next_day.strftime('%Y-%m-%d')} 15:00:00", home_team: 'Spurs', away_team: 'Hull'}
        ]
      end

      before do
        stub_fixtures = {
            Date.today.next_day.strftime('%Y-%m-%d') => [
                {home_team: 'Arsenal', away_team: 'Everton'},
                {home_team: 'Chelsea', away_team: 'Stoke'},
                {home_team: 'Spurs', away_team: 'Hull'}
            ]}
        stub_fixtures_request base_uri, stub_fixtures
      end

      it 'return all fixtures from day 1' do
        expect(subject.retrieve_new_fixtures).to eq(fixtures)
      end
    end

    context 'when no fixtures in future' do
      before do
        stub_fixtures_request base_uri, {}
      end

      it 'returns no fixtures' do
        expect(subject.retrieve_new_fixtures).to eq([])
      end

    end
  end


  def stub_fixtures_request base_uri, fixtures
    template = Tilt::ERBTemplate.new File.new 'features/responses/fixtures.html.erb'
    response = template.render(nil, {:fixtures_by_date => fixtures})
    stub_request(:get, "#{base_uri}/en-gb/matchday/matches.html?paramClubId=ALL&paramComp_8=true&view=.dateSeason").to_return(status: 200, body: response)
  end

end