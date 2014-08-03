require 'mirage/client'
Mirage.start.clear
module Mirage
  module Cucumber
    def mirage
      @mirage ||= Mirage::Client.new
    end
  end
end
World Mirage::Cucumber

