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
  end
end