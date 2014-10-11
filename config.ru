$stdout.sync = true #disable ruby output buffering https://devcenter.heroku.com/articles/getting-started-with-ruby-o

Bundler.require

module Fbl
  class App < Sinatra::Base

    configure :development do
      set :premier_league_url, 'http://localhost:7001/responses'
    end

    configure :integration do
      set :premier_league_url, 'http://www.premierleague.com'
    end

    configure do
      ActiveRecord::Base.logger.level = Logger::WARN
    end
  end
end

__dir__ = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{__dir__}/lib")

require 'fbl/app'
run Fbl::App
