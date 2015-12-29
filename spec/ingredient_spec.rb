require 'ingredient'

describe "Ingredient" do
  before(:each) do
    Ingredient.all.destroy
    Good.all.destroy
    Ingredient.all.destroy
  end

  it "should compose a recipe and have a good" do
    recipe = Recipe.new
    recipe.name = "pancake"

    good = Good.new
    good.name = "flour"
    good.unit = "kg"
    good.unit_size = 1
    good.price_per_unit = 1000

    ingredient = Ingredient.new
    ingredient.quantity = 3
    ingredient.recipe = recipe
    ingredient.good = good


    expect(ingredient.save).to be_truthy
    expect(ingredient.recipe.name).to eq("pancake")
    expect(ingredient.good.name).to eq("flour")
  end

end
