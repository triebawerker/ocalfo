require 'sinatra/base'
require 'json'
require_relative 'good'
require_relative 'recipe'
require_relative 'ingredient'

class App < Sinatra::Base



  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/ocalfo_test.db")
  DataMapper::Logger.new($stdout, :debug)

  configure do
    set :views, File.dirname(__FILE__) + '/../views'
    set :title, "ocalfo"

    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false
  end

  get '/' do
    erb :index
  end

  get '/recipes.json' do
    recipes = []
    Recipe.all.each do |recipe|
      recipes << { :name => recipe.name, :ingredients => recipe.ingredients }
    end

    content_type :json
    recipes.to_json
  end

  post '/order.json' do
    content_type :json

    order = []

    items = JSON.parse request.body.read

    items['recipes'].each do |item|

      recipe = Recipe.get(item['recipe_id'].to_i)
      order_quantity = item['quantity']

      recipe.ingredients.each do |ingredient|

        good = Good.get(ingredient.good.id)

        #calculate quantity of units
        quantity = ((ingredient.quantity * order_quantity.to_i).to_f / good.unit_size.to_f).ceil
        order << {:name => good.name, :quantity => quantity}

      end
    end

    order.to_json

  end

  get '/goods' do

    @goods = Good.all
    erb :goods

  end

  get '/goods.json' do
    goods = []
    Good.all.each do |good|
      goods << { :name => good.name,
        :unit => good.unit,
        :unit_size => good.unit_size,
        :price_per_unit => good.price_per_unit
        }
    end

    content_type :json
    goods.to_json
  end

  get '/ingredients.json' do

    ingredients = []
    Ingredient.all.each do |ingredient|
      DataMapper.logger.debug("ingredient in ingredient: #{ingredient.recipe.name}")
      ingredients << {
        :recipe => ingredient.recipe.name,
        :recipe_id => ingredient.recipe.id,
        :good => ingredient.good.name,
        :good_id => ingredient.good.id,
        :quantity => ingredient.quantity,
        :unit => ingredient.good.unit
        }
    end

    content_type :json
    ingredients.to_json
  end

end
