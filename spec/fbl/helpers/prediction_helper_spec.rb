require 'spec_helper'
require 'fbl/helpers/prediction_helper'

describe Fbl::PredictionHelper do
  include_context :database

  before :all do
    establish_connection
  end

  before do
    Prediction.destroy_all
  end

  let(:subject) { Object.new.extend(described_class) }

  context '#save_prediction' do
    let(:prediction) { {home_team: 'Arsenal', away_team: 'Chelsea', goal_scorer: 'Theo Walcott', kick_off: '2014-10-12 15:00:00', home_team_score: 2, away_team_score: 1, user_id: 1} }

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

  context '#invalid_prediction_indexes' do
    let(:user_one_id) { 1 }
    let(:user_two_id) { 2 }
    let(:predictions) do
      [{home_team: 'Arsenal', away_team: 'Chelsea', goal_scorer: 'Theo Walcott',
        kick_off: '2014-10-12 15:00:00', home_team_score: 2, away_team_score: 1, user_id: user_one_id}]
    end

    context 'exact prediction already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(predictions)
        expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([0])
      end
    end

    context 'prediction with same goalscorer already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(predictions)

        predictions.first.merge!(home_team_score: 3)

        expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([])
      end
    end

    context 'prediction with same scoreline already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(predictions)

        predictions.first.merge!(goal_scorer: 'Jack Wilshere')

        expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([])
      end
    end

    context 'multiple predictions' do
      let(:prediction_one) do
        {home_team: 'Arsenal', away_team: 'Chelsea', goal_scorer: 'Theo Walcott',
         kick_off: '2014-10-12 15:00:00', home_team_score: 2, away_team_score: 1, user_id: user_one_id}
      end
      let(:prediction_two) do
        {home_team: 'Liverpool', away_team: 'Burnley', goal_scorer: 'Steven Gerard',
         kick_off: '2014-10-12 15:00:00', home_team_score: 3, away_team_score: 0, user_id: user_one_id}
      end
      let(:predictions) { [prediction_one, prediction_two] }

      before do
        Prediction.create(predictions)
      end

      context 'where both are the same as another users' do
        it 'should return both indexes' do
          expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([0, 1])
        end
      end

      context ' where second prediction the same as another user' do
        it 'should return second index' do
          prediction_one.merge!(home_team_score: 1)
          expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([1])
        end

      end

      context ' where both unique' do
        it 'should return no indexes' do
          prediction_one.merge!(home_team_score: 1)
          prediction_two.merge!(home_team_score: 4)
          expect(subject.invalid_prediction_indexes(user_two_id, predictions)).to eq([])
        end
      end

    end
  end

  context '#opposing_users_predictions' do
    let(:user_id) { 1 }
    let(:user_id_two) { 2 }
    let(:user_id_three) { 3 }
    let(:home_team_score) { 2 }
    let(:away_team_score) { 1 }
    let(:home_team) { 'Arsenal' }
    let(:away_team) { 'Chelsea' }
    let(:another_away_team) { 'Man Utd' }
    let(:goal_scorer) { 'Theo Walcott' }
    let(:kick_off) { '2014-10-12 15:00:00' }

    context 'other users have not made predictions' do

      it 'returns no predictions' do
        expect(subject.opposing_users_predictions home_team, away_team, 1).to eq([])
      end
    end

    context 'predictions been made for a different game' do
      before do
        @prediction = Prediction.create({home_team: home_team, away_team: another_away_team, goal_scorer: goal_scorer,
                                         kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_two})
      end

      it 'returns no predictions' do
        expect(subject.opposing_users_predictions home_team, away_team, user_id).to eq([])
      end
    end

    context 'other user has made predictions' do
      before do
        @prediction = Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                                         kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_two})
      end

      it 'returns predictions' do
        expect(subject.opposing_users_predictions home_team, away_team, user_id).to eq([@prediction])
      end
    end

    context 'multiple users have made predictions' do
      before do
        @prediction_one = Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                                             kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_two})
        @prediction_two = Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                                             kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_three})
      end

      it 'returns predictions' do
        expect(subject.opposing_users_predictions home_team, away_team, user_id).to eq([@prediction_one, @prediction_two])
      end
    end

    context 'multiple users including provided user' do
      before do
        @prediction_one = Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                                             kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_two})
        @prediction_two = Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                                             kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_three})
        Prediction.create({home_team: home_team, away_team: away_team, goal_scorer: goal_scorer,
                           kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id})
      end

      it 'returns other users predictions' do
        expect(subject.opposing_users_predictions home_team, away_team, user_id).to eq([@prediction_one, @prediction_two])
      end
    end
  end

end
