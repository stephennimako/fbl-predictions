require 'model/prediction'
require 'model/user'
require 'model/fixture'

module Fbl
  module PredictionHelper
    def save_prediction prediction_with_fixture
      fixture = find_fixture(prediction_with_fixture)
      prediction = prediction_with_fixture.slice(:home_team_score, :away_team_score, :user_id, :goal_scorer, :additional_goal_scorer).merge(fixture_id: fixture.id)
      current_prediction = Prediction.find_by(user_id: prediction[:user_id], fixture_id: fixture.id)
      if current_prediction
        Prediction.update(current_prediction.id, prediction)
      else
        Prediction.create(prediction)
      end
    end

    def invalid_prediction_indexes user_id, submitted_predictions
      indexes = []
      submitted_predictions.each_with_index do |prediction, index|
        fixture = find_fixture(prediction)
        indexes << index if Prediction.where(prediction.slice(:home_team_score, :away_team_score, :goal_scorer, :additional_goal_scorer).merge(fixture_id: fixture.id)).where.not(user_id: user_id).count > 0
      end
      indexes
    end

    def opposing_users_predictions fixture, user_id
      opposition_predictions = []
      fixture = Fixture.find_by(fixture)
      predictions = Prediction.where(fixture_id: fixture.id).where.not(user_id: user_id)
      predictions.each do |prediction|
        opposition_predictions << prediction
      end
      opposition_predictions
    end

    def current_users_prediction fixture, user_id
      fixture = Fixture.find_by(fixture)
      Prediction.find_by(fixture_id: fixture.id, user_id: user_id)
    end

    private

    def find_fixture(prediction_hash)
      Fixture.find_by(prediction_hash.slice(:home_team, :away_team, :kick_off))
    end

  end
end