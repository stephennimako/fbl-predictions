module Fbl
  class App < Sinatra::Base

    get '/' do
      env['warden'].authenticate!
      @current_user = env['warden'].user
      erb :predictions
    end
  end
end