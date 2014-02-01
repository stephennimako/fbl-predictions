Bundler.require

__dir__ = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{__dir__}/lib")
require 'fbl/app'

run Fbl::App
