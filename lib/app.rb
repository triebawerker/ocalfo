require 'bundler'
Bundler.require

require 'sinatra/base'
require 'dm-serializer'
require_relative 'good'
require_relative 'recipe'
require_relative 'ingredient'
require 'json'

class App < Sinatra::Base


  configure :development do
    DataMapper.setup(:default, 'postgres://localhost/ocalfo')
    DataMapper::Logger.new($stdout, :debug)
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

    configure do
    set :views, File.dirname(__FILE__) + '/../views'
    set :title, "ocalfo"

    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false

    DataMapper.finalize
    Recipe.auto_migrate!
    Ingredient.auto_migrate!
    Good.auto_migrate!

  end

  get '/' do
    erb :index
  end

  get '/recipes.json' do
    recipes = []
    Recipe.all.each do |recipe|

      ingredients = []

      recipe.ingredients.each do |ingredient|

        ingredients << {
          :recipe => ingredient.recipe.name,
          :recipe_id => ingredient.recipe.id,
          :good => ingredient.good.name,
          :good_id => ingredient.good.id,
          :quantity => ingredient.quantity,
          :unit => ingredient.good.unit,
          :unit_size => ingredient.good.unit_size
          }
      end
      recipes << {
        :name => recipe.name,
        :ind => recipe.id,
        :ingredients => ingredients,
        }
    end

    content_type :json
    recipes.to_json
  end

  post '/order.json' do
    content_type :json

    order = []
    recipes = JSON.parse(request.body.read)

    recipes['recipes'].each do |item|

      recipe = Recipe.get(item['recipe_id'].to_i)
      order_quantity = item['quantity']

      recipe.ingredients.each do |ingredient|

        good = Good.get(ingredient.good.id)

        #calculate quantity of units
        quantity = ((ingredient.quantity * order_quantity.to_i).to_f / good.unit_size.to_f).ceil
        order << {
          :name => good.name,
          :quantity => quantity,
          :unit => ingredient.good.unit,
          :unit_size => ingredient.good.unit_size
          }

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
      goods << {
        :id => good.id,
        :name => good.name,
        :unit => good.unit,
        :unit_size => good.unit_size,
        :price_per_unit => good.price_per_unit
        }
    end

    content_type :json
    goods.to_json
  end

  post '/goods.json' do
    content_type = :json

    data = JSON.parse(request.body.read)
    good = Good.new(data['good'])

    if good.save
      good.to_json
    else
          halt 500
    end
  end

  get '/ingredients.json' do

    ingredients = []
    Ingredient.all.each do |ingredient|
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

  put '/goods.json/:id' do
    content_type :json

    data = JSON.parse(request.body.read)
    good = Good.get(params['id'])

    if good.update(data['good'])
      good.to_json
    else
      halt 500
    end

  end


end
