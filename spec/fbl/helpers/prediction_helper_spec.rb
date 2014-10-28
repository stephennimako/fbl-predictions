require 'spec_helper'
require 'fbl/helpers/prediction_helper'

describe Fbl::PredictionHelper do
  include_context :database

  before do
    Fixture.destroy_all
    Prediction.destroy_all

    @saved_fixture = Fixture.create(
        {kick_off: kick_off, home_team: home_team, away_team: away_team}
    )
  end

  let(:subject) { Object.new.extend(described_class) }

  let(:kick_off) { '2014-10-12 15:00:00' }
  let(:home_team) { 'Arsenal' }
  let(:away_team) { 'Chelsea' }
  let(:home_team_score) { 2 }
  let(:away_team_score) { 1 }
  let(:goal_scorer) { 'Theo Walcott' }
  let(:user_id_one) { 1 }
  let(:user_id_two) { 2 }
  let(:user_id_three) { 3 }

  let(:prediction) { {home_team_score: home_team_score, away_team_score: away_team_score, goal_scorer: goal_scorer, user_id: user_id_one}.merge(fixture_id: @saved_fixture.id) }

  context '#save_prediction' do

    let(:submitted_prediction) { {home_team: home_team, away_team: away_team, goal_scorer: goal_scorer, kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score, user_id: user_id_one} }

    context 'A prediction does not exist for fixture and user' do
      it 'create new prediction' do
        subject.save_prediction submitted_prediction
        expect(Prediction.find_by(prediction)).to_not be_nil
      end
    end

    context 'A prediction exists for fixture and user' do
      it 'overwrite existing prediction' do
        Prediction.create prediction

        subject.save_prediction submitted_prediction
        expect(Prediction.find_by(prediction)).to_not be_nil
      end
    end
  end

  context '#invalid_prediction_indexes' do
    let(:submitted_prediction) { {home_team: home_team, away_team: away_team, goal_scorer: goal_scorer, kick_off: kick_off, home_team_score: home_team_score, away_team_score: away_team_score} }

    context 'exact prediction already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(prediction)
        expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction])).to eq([0])
      end
    end

    context 'prediction with same goalscorer already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(prediction)
        submitted_prediction.merge!(home_team_score: 3)
        expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction])).to eq([])
      end
    end

    context 'prediction with same scoreline already made by another user' do
      it 'should return index of invalid prediction index' do
        Prediction.create(prediction)
        submitted_prediction.merge!(goal_scorer: 'Jack Wilshere')

        expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction])).to eq([])
      end
    end

    context 'multiple predictions' do
      let(:home_team_two) { 'Liverpool' }
      let(:away_team_two) { 'Burnley' }
      let(:home_team_score_two) { 3 }
      let(:away_team_score_two) { 0 }

      let(:prediction_two) do
        {goal_scorer: 'Steven Gerard', home_team_score: home_team_score_two, away_team_score: away_team_score_two, fixture_id: @saved_fixture_two.id, user_id: user_id_one}
      end

      let(:submitted_prediction_two) { {home_team: home_team_two, away_team: away_team_two, kick_off: kick_off, goal_scorer: 'Steven Gerard', home_team_score: home_team_score_two, away_team_score: away_team_score_two} }

      before do
        @saved_fixture_two = Fixture.create(
            {kick_off: kick_off, home_team: home_team_two, away_team: away_team_two}
        )
        Prediction.create([prediction, prediction_two])
      end

      context 'where both are the same as another users' do
        it 'should return both indexes' do
          expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction, submitted_prediction_two])).to eq([0, 1])
        end
      end

      context ' where second prediction the same as another user' do
        it 'should return second index' do
          submitted_prediction.merge!(home_team_score: 1)
          expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction, submitted_prediction_two])).to eq([1])
        end
      end

      context ' where both unique' do
        it 'should return no indexes' do
          submitted_prediction.merge!(home_team_score: 1)
          submitted_prediction_two.merge!(home_team_score: 4)
          expect(subject.invalid_prediction_indexes(user_id_two, [submitted_prediction, submitted_prediction_two])).to eq([])
        end
      end
    end
  end

  context '#opposing_users_predictions' do
    let(:another_away_team) { 'Man Utd' }
    let(:fixture) { {home_team: home_team, away_team: away_team, kick_off: kick_off} }
    let(:another_fixture) { {home_team: home_team, away_team: another_away_team, kick_off: kick_off} }

    context 'other users have not made predictions' do

      it 'returns no predictions' do
        expect(subject.opposing_users_predictions fixture, user_id_one).to eq([])
      end
    end

    context 'other users have made predictions for a different game' do

      before do
        @another_saved_fixture = Fixture.create(another_fixture)
        @prediction = Prediction.create(prediction.merge(fixture_id: @another_saved_fixture.id, user_id: user_id_two))
      end

      it 'returns no predictions' do
        expect(subject.opposing_users_predictions(fixture, user_id_one)).to eq([])
      end
    end

    context 'other user has made predictions for provided fixture' do
      before do
        @prediction = Prediction.create(prediction.merge(user_id: user_id_two))
      end

      it 'returns predictions' do
        expect(subject.opposing_users_predictions fixture, user_id_one).to eq([@prediction])
      end
    end

    context 'multiple users have made predictions' do
      before do
        @prediction_one = Prediction.create(prediction.merge(user_id: user_id_two))
        @prediction_two = Prediction.create(prediction.merge(user_id: user_id_three))
      end

      it 'returns predictions' do
        expect(subject.opposing_users_predictions fixture, user_id_one).to eq([@prediction_one, @prediction_two])
      end
    end

    context 'multiple users including provided user' do
      before do
        @prediction_one = Prediction.create(prediction.merge(user_id: user_id_two))
        @prediction_two = Prediction.create(prediction.merge(user_id: user_id_three))
        Prediction.create(prediction.merge(user_id: user_id_one))
      end

      it 'returns other users predictions' do
        expect(subject.opposing_users_predictions fixture, user_id_one).to eq([@prediction_one, @prediction_two])
      end
    end
  end

  context '#current_users_prediction' do
    context 'prediction exists' do
      it 'returns prediction' do
        saved_prediction = Prediction.create(prediction)
        expect(subject.current_users_prediction({home_team: home_team, away_team: away_team, kick_off: kick_off}, user_id_one)).to eq(saved_prediction)
      end
    end

    context 'prediction does not exists' do
      it 'returns nil' do
        expect(subject.current_users_prediction({home_team: home_team, away_team: away_team, kick_off: kick_off}, user_id_one)).to be_nil
      end
    end
  end
end
