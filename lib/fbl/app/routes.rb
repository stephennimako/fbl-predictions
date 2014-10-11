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
      content_type :json

      predictions = JSON.parse(request.body.read)

      predictions.each do |prediction|
        save_prediction(prediction)
      end

      {success: true}.to_json
    end

  end
end