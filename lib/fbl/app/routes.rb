require 'json'
require 'model/prediction'
require 'fbl/helpers/fixtures'
require 'fbl/helpers/goal_scorers'
require 'fbl/helpers/prediction_helper'

module Fbl
  class App < Sinatra::Base

    helpers Fbl::Fixtures, Fbl::GoalScorers, Fbl::PredictionHelper

    get '/' do
      authenticate_user
      slim :predictions
    end

    post '/predictions' do
      authenticate_user
      content_type :json

      predictions = JSON.parse(request.body.read)
      indexes = invalid_prediction_indexes(@current_user.id, predictions)
      if indexes.empty?
        predictions.each do |prediction|
          save_prediction(prediction.merge user_id: @current_user.id)
        end
        {success: true}.to_json
      else
        {success: false, invalid_predictions_indexes: indexes}.to_json
      end
    end

  end
end