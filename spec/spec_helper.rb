Bundler.require
require 'timecop'
require 'fbl/db/settings'
require 'active_support/core_ext/hash'

shared_context :database do
  def establish_connection
    ActiveRecord::Base.logger = nil
    ActiveRecord::Base.establish_connection(Fbl::Database::CONFIG)
  end

  before :all do
    establish_connection
  end
end