require 'bundler'
Bundler.require

class Recipe
  include DataMapper::Resource

  property :id,   Serial, :key => true
  property :name, String

  has n, :ingredients
end
