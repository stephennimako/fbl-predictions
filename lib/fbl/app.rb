$LOAD_PATH.unshift(__dir__)

require 'app/authentication'
require 'app/routes'

module Fbl
  class App < Sinatra::Base
    set :root, "#{__dir__}/../../"
  end
end