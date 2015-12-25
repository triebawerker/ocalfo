require File.dirname(__FILE__) + '/spec_helper'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'  # <-- your sinatra app

describe 'The calculate food order site ' do

  before(:each) do
    Recipe.all.destroy
    Ingredience.all.destroy
    Good.all.destroy

    Recipe.create(:name => 'pancake')
    Recipe.create(:name => 'omelette')

    @pancake = Recipe.first(:name => 'pancake')

    Good.create(
    :name => "flour",
    :unit => "kg",
    :unit_size => 1,
    :price_per_unit => 1000)

  end

  def app
    App
  end

  it "shows the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end

  it "should return all recipes" do


    get '/recipes.json'
    expect(last_response).to be_ok

    recipes = JSON::parse(last_response.body)
    expect(recipes.size).to be 2
    expect(recipes[0]['name']).to eq("pancake")
    expect(recipes[1]['name']).to eq("omelette")
  end

  it "should calculate an order for a recipe" do
    get '/order.json'

    expect(last_response).to be_ok
  end

  it "should have ingredience for a recipe" do
    ingredience = Ingredience.new
    ingredience.name = "egg"
    ingredience.quantity = 3
    ingredience.save

    @pancake.ingrediences << ingredience
    @pancake.save

    get '/recipes.json'

    recipes = JSON::parse(last_response.body)

    expect(last_response).to be_ok
    expect(recipes.size).to be 2
    expect(recipes[0]['name']).to eq("pancake")
    expect(recipes[1]['name']).to eq("omelette")
    expect(ingredience.recipe).to be_a(Recipe)
  end

  it "should get the goods" do
    get 'goods.json'

    goods = JSON::parse(last_response.body)

    DataMapper::Logger.new($stdout, :debug)
    DataMapper.logger.debug(goods[0]["name"])


    expect(goods[0]["name"]).to eq("flour")
  end

end
