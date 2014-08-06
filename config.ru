Bundler.require

__dir__ = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{__dir__}/lib")

require 'fbl/helpers/fixtures'
require 'fbl/helpers/players'

module Fbl
  class App < Sinatra::Base

    helpers Fbl::Fixtures, Fbl::Players
    configure :development do
      set :premier_league_url, 'http://localhost:7001/responses'
    end

    configure :integration do
      set :premier_league_url, 'http://www.premierleague.com'
    end
  end
end

require 'fbl/app'
run Fbl::App
