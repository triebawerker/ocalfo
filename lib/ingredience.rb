class Ingredience
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, String
  property :quantity, Integer

  belongs_to :recipe
end
