require 'fbl/db/settings'

module Fbl
  class App < Sinatra::Base
    configure do
      ActiveRecord::Base.establish_connection(Fbl::Database::CONFIG)
    end
  end
end