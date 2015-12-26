require 'bundler'
Bundler.require

class Ingredient
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :quantity, Integer

  belongs_to :recipe
  belongs_to :good
end
