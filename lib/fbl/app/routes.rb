module Fbl
  class App < Sinatra::Base

    get '/' do
      authenticate_user
      slim :predictions
    end

    private

    def authenticate_user
      env['warden'].authenticate!
      @current_user = env['warden'].user
    end

  end
end