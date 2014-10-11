require 'spec_helper'
require 'fbl/helpers/prediction_helper'

describe Fbl::PredictionHelper do
  include_context :database

  context '#save_prediction' do
    let(:subject) { Object.new.extend(described_class) }
    let(:prediction) { {home_team: 'Arsenal', away_team: 'Chelsea', goal_scorer: 'Theo Walcott', kick_off: '2014-10-12 15:00:00', home_team_score: 2, away_team_score: 1, user_id: 1} }

    before :all do
      establish_connection
    end

    before do
      Prediction.destroy_all
    end

    context 'A prediction does not exist for fixture and user' do
      it 'create new prediction' do
        subject.save_prediction prediction
        expect(Prediction.all.count).to eq(1)
        expect(Prediction.find_by(prediction)).to_not be_nil
      end
    end

    context 'A prediction exists for fixture and user' do
      it 'overwrite existing prediction' do
        original_prediction = {home_team: 'Arsenal', away_team: 'Chelsea', goal_scorer: 'Theo Walcott', kick_off: '2014-10-12 15:00:00', home_team_score: 1, away_team_score: 0, user_id: 1}
        Prediction.create original_prediction
        subject.save_prediction prediction
        expect(Prediction.all.count).to eq(1)
        expect(Prediction.find_by(prediction)).to_not be_nil
      end
    end

  end

end
