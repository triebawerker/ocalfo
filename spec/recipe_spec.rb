describe "Test api" do
  before(:each) do
    Recipe.all.destroy
  end

  it "should add recipe" do
    recipe = Recipe.new
    recipe.name = 'Pfannkuchen'

    expect(recipe.save).to be_truthy
  end
end
