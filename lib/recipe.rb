class Recipe
  include DataMapper::Resource

  property :id,   Serial, :key => true
  property :name, String
end
