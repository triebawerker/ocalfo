require File.dirname(__FILE__) + '/spec_helper'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'  # <-- your sinatra app
require 'tilt/erb'

describe 'The calculate food order site ' do

  before(:each) do
    Recipe.all.destroy
    Ingredient.all.destroy
    Good.all.destroy

    Recipe.create(:name => 'pancake')
    Recipe.create(:name => 'omelette')

    Good.create(
    :name => "flour",
    :unit => "g",
    :unit_size => 1000,
    :price_per_unit => 199)

    Good.create(
      :name => "sugar",
      :unit => "g",
      :unit_size => 1000,
      :price_per_unit => 99)

    @flour = Good.first(:name => "flour")
    @sugar = Good.first(:name => "sugar")

    @pancake = Recipe.first(:name => "pancake")

    Ingredient.create(
      :good => @flour,
      :quantity => 100,
      :recipe => @pancake)

    Ingredient.create(
      :good => @sugar,
      :quantity => 50,
      :recipe => @pancake)

  end

  def app
    App
  end

  it "shows the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to have_tag('h1', :text  => 'API documentation')
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

    post '/order.json', {"recipe_id": 1, "quantity": 23}

    order = JSON::parse(last_response.body)

#     DataMapper.logger.debug(order[0].inspect)

    expect(last_response).to be_ok
    expect(order[0]['name']).to eq "flour"
    expect(order[0]['quantity']).to eq 3
    expect(order[1]['name']).to eq "sugar"
    expect(order[1]['quantity']).to be 2
  end

  it "should have ingredient for a recipe" do
    ingredient = Ingredient.new
    ingredient.quantity = 3
    ingredient.save

    @pancake.ingredients << ingredient
    @pancake.save

    get '/recipes.json'

    recipes = JSON::parse(last_response.body)

    expect(last_response).to be_ok
    expect(recipes.size).to be 2
    expect(recipes[0]['name']).to eq("pancake")
    expect(recipes[1]['name']).to eq("omelette")
    expect(ingredient.recipe).to be_a(Recipe)
  end

  it "should get the goods" do
    get 'goods.json'

    goods = JSON::parse(last_response.body)

    expect(goods[0]["name"]).to eq("flour")
  end

end
