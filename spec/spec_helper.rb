Bundler.require
require 'fbl/db/settings'

shared_context :database do
  def establish_connection
    ActiveRecord::Base.logger.level = Logger::WARN
    ActiveRecord::Base.establish_connection(Fbl::Database::CONFIG)
  end
end