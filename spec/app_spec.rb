require File.dirname(__FILE__) + '/spec_helper'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'  # <-- your sinatra app
require 'tilt/erb'
require 'json'

describe 'The calculate food order site ' do

  before(:each) do
    Recipe.all.destroy
    Ingredient.all.destroy
    Good.all.destroy

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

    recipes = Recipe.all

    recipes_for_order = { :recipes => []}

    recipes.each do |recipe|
      recipes_for_order[:recipes] << {:recipe_id => recipe.id, :quantity => 23}
    end

    post '/order.json', recipes_for_order.to_json

    order = JSON.parse last_response.body

    expect(last_response).to be_ok
    expect(order[0]['name']).to eq "flour"
    expect(order[0]['quantity']).to eq 3
    expect(order[1]['name']).to eq "sugar"
    expect(order[1]['quantity']).to be 2
  end

  it "should have ingredient for a recipe" do

    get '/recipes.json'

    recipes = JSON::parse(last_response.body)

    expect(last_response).to be_ok
    expect(recipes.size).to be 2
    expect(recipes[0]['name']).to eq("pancake")
    expect(recipes[1]['name']).to eq("omelette")

    recipe = Recipe.first(:name => recipes[0]['name'])
    ingredient = Ingredient.first(recipe)

    expect(ingredient['recipe_id'].to_i).to be recipe['id'].to_i
  end

  it "should get the goods" do
    get 'goods.json'

    goods = JSON::parse(last_response.body)

    expect(goods[0]["name"]).to eq("flour")
  end

  it "should return ingredients as json" do
    get 'ingredients.json'

    expect(last_response).to be_ok
  end

  it "should add a good" do
    data =  {
      :good => {
        :name => "soup",
        :unit => "litre",
        :unit_size => 1000,
        :price_per_unit => 500
        }
      }
    post 'goods.json', data.to_json

    expect(last_response).to be_ok

    good = JSON.parse(last_response.body)
    expect(good['name']).to eq "soup"
    expect(good['unit']).to eq "litre"

  end

  it "should update a good" do

    flour = Good.first(:name => "flour")

    flour.name = "spelt"

    data = { :id => flour.id, :good => flour }

    put 'goods.json/:id', data.to_json

    good = JSON.parse(last_response.body)
    expect(good['name']).to eq "spelt"
  end

end
