require 'sinatra/base'
require 'json'
require_relative 'good'

class App < Sinatra::Base

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/ocalfo_test.db")

  set :views, File.dirname(__FILE__) + '/../views'
  set :title, "ocalfo"

  get '/' do
    'Hello World!'
  end

  get '/recipes.json' do
    recipes = []
    Recipe.all.each do |recipe|
      recipes << { :name => recipe.name, :ingrediences => recipe.ingrediences }
    end

    content_type :json
    recipes.to_json
  end

  get '/order.json' do
    'order'

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
