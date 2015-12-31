require 'rubygems'
require 'rack/test'
require 'rspec'
require 'dm-core'
require 'dm-migrations'

require 'recipe'
require 'ingredient'
require 'good'
require 'rspec-html-matchers'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include RSpecHtmlMatchers

end



