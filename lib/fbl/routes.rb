require 'sinatra/base'

module Fbl
  class App < Sinatra::Base

    get '/' do
      'Submit your Predictions'
    end
  end
end