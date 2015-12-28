require 'sinatra/base'
require 'json'
require_relative 'good'

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

    order_quantity = params['quantity']

    DataMapper.logger.debug("params: #{params.inspect}")

    recipe = Recipe.first(:name => "pancake")

#     order = {:order_id => 1, :name => "flour", :quantity => 100}

    recipe.ingredients.each do |ingredient|
      good = Good.get(ingredient.good.id)

      #calculate quntity of units

      DataMapper.logger.debug(
        "INGREDIENT: #{ingredient.quantity}, unit_size: #{good.unit_size}"
        )

      quantity = ((ingredient.quantity * order_quantity.to_i).to_f / good.unit_size.to_f).ceil
      order << {:name => good.name, :quantity => quantity}



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
end
