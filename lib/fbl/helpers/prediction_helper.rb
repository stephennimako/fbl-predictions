require 'model/prediction'
require 'model/user'
require 'active_support/core_ext/hash'

module Fbl
  module PredictionHelper
    def save_prediction prediction
      current_prediction = Prediction.find_by(prediction.except(:home_team_score, :away_team_score, :goal_scorer, :additional_goal_scorer))
      if current_prediction
        Prediction.update(current_prediction.id, prediction)
      else
        Prediction.create(prediction)
      end
    end

    def invalid_prediction_indexes user_id, predictions
      indexes = []
      predictions.each_with_index do |prediction, index|
        indexes << index if Prediction.where(prediction).where.not(user_id: user_id).count > 0
      end
      indexes
    end

    def opposing_users_predictions home_team, away_team, user_id
      opposition_predictions = []
      predictions = Prediction.where(home_team: home_team, away_team: away_team).where.not(user_id:user_id)
      predictions.each do |prediction|
        opposition_predictions << prediction
      end
      opposition_predictions
    end
  end
end