Bundler.require :test

require 'model/user'

Capybara.app_host = "http://localhost:9291"
Capybara.run_server = false
Capybara.default_driver = :poltergeist

WebMock.allow_net_connect!