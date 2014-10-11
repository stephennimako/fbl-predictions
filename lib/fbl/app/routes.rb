require 'json'
require 'model/prediction'
require 'fbl/helpers/fixtures'
require 'fbl/helpers/goal_scorers'
module Fbl
  class App < Sinatra::Base

    helpers Fbl::Fixtures, Fbl::GoalScorers

    get '/' do
      authenticate_user
      slim :predictions
    end

    post '/predictions' do
      content_type :json

      predictions = JSON.parse(request.body.read)
      Prediction.create(predictions)

      {success: true}.to_json
    end

    private

    def authenticate_user
      env['warden'].authenticate!
      @current_user = env['warden'].user
    end

  end
end