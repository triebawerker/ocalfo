require 'ingredience'

describe "Ingredience api" do
  before(:each) do
    Ingredience.all.destroy
  end

  it "should add an ingredience for a recipe" do
    recipe = Recipe.new
    recipe.name = "pancake"

    ingredience = Ingredience.new
    ingredience.name = 'egg'
    ingredience.quantity = 3
    ingredience.recipe = recipe


    expect(ingredience.save).to be_truthy
    expect(ingredience.recipe.name).to eq("pancake")
  end
end
