Bundler.require
require 'fbl/db/settings'

shared_context :database do
  def establish_connection
    ActiveRecord::Base.logger = nil
    ActiveRecord::Base.establish_connection(Fbl::Database::CONFIG)
  end
end