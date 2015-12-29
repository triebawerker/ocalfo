require_relative 'app'

class Seed

  Recipe.all.destroy
  Good.all.destroy
  Ingredient.all.destroy

  DataMapper.finalize

  def self.create_seeds

    @pancake = Recipe.create(:name => 'pancake')
    @omelette = Recipe.create(:name => 'omelette')

    @flour = Good.create(
    :name => "flour",
    :unit => "g",
    :unit_size => 1000,
    :price_per_unit => 199)

    @sugar = Good.create(
      :name => "sugar",
      :unit => "g",
      :unit_size => 1000,
      :price_per_unit => 99)

    @butter = Good.create(
      :name => "butter",
      :unit => "g",
      :unit_size => 250,
      :price_per_unit => 199)

    @salt = Good.create(
      :name => "salt",
      :unit => "g",
      :unit_size => 500,
      :price_per_unit => 99)

    @egg = Good.create(
      :name => "egg",
      :unit => "peace",
      :unit_size => 10,
      :price_per_unit => 299)

    Ingredient.create(
      :good => @flour,
      :quantity => 100,
      :recipe => @pancake)

    Ingredient.create(
      :good => @sugar,
      :quantity => 50,
      :recipe => @pancake)

    Ingredient.create(
      :good => @salt,
      :quantity => 1,
      :recipe => @pancake)

    Ingredient.create(
      :good => @egg,
      :quantity => 5,
      :recipe => @pancake)

    Ingredient.create(
      :good => @egg,
      :quantity => 4,
      :recipe => @omelette)

    Ingredient.create(
      :good => @salt,
      :quantity => 1,
      :recipe => @omelette)

    Ingredient.create(
      :good => @butter,
      :quantity => 10,
      :recipe => @omelette)
  end

end

Seed::create_seeds
