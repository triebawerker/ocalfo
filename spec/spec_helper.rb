require 'rubygems'
require 'rack/test'
require 'rspec'
require 'dm-core'
require 'dm-migrations'

require 'recipe'
require 'ingredient'
require 'good'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include RSpecHtmlMatchers
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/ocalfo_test.db")
  DataMapper.finalize
  Recipe.auto_migrate!
  Ingredient.auto_migrate!
  Good.auto_migrate!
end


