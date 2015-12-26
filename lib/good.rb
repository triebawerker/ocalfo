require 'bundler'
Bundler.require

class Good
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, String
  property :unit, String
  property :unit_size, Integer
  property :price_per_unit, Integer

  has n, :ingredients

end
