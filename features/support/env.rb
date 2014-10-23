Bundler.require :test

Capybara.app_host = "http://localhost:9291"
Capybara.run_server = false
Capybara.default_driver = :poltergeist
Capybara.default_wait_time = 5

WebMock.allow_net_connect!

require 'sinatra/activerecord'
require 'fbl/db/settings'

ActiveRecord::Base.establish_connection(Fbl::Database::CONFIG)
ActiveRecord::Base.logger.level = Logger::WARN