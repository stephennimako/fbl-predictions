require 'fbl/helpers/fixtures'
require 'spec_helper'

describe Fbl::Fixtures do
  let(:subject) { Object.new.extend(described_class) }

  context 'when fixtures include selected teams and unselected teams' do

    before do
      fixtures = [
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Chelsea', away_team: 'Stoke'},
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Aston Villa', away_team: 'Sunderland'}
      ]

      Fbl::Service::FixturesService.any_instance.stub(:current_round).and_return(fixtures)
      subject.stub(:settings).and_return(double(:settings, {premier_league_url:'http://localhost:7001/responses'}))
    end

    it 'returns selected fixtures' do
      filtered_fixtures = [
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Arsenal', away_team: 'Everton'},
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Chelsea', away_team: 'Stoke'}
      ]
      expect(subject.filtered_fixtures).to eq(filtered_fixtures)
    end
  end

  context 'when fixtures include unselected teams' do

    before do
      fixtures = [
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'West Brom', away_team: 'Stoke'},
          {kick_off: "#{Date.today.next_day.strftime('%A %d %B %Y')} 15:00:00", home_team: 'Aston Villa', away_team: 'Sunderland'}
      ]

      Fbl::Service::FixturesService.any_instance.stub(:current_round).and_return(fixtures)
      subject.stub(:settings).and_return(double(:settings, {premier_league_url:'http://localhost:7001/responses'}))
    end

    it 'should return no fixtures' do
      expect(subject.filtered_fixtures).to eq([])
    end
  end
end