require 'model/prediction'
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
  end
end