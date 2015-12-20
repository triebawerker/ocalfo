require 'sinatra'
require 'json'

get '/' do
  'Hello World!'
end

get '/recipes.json' do
  recipes = []
  Recipe.all.each do |recipe|
    recipes << { :name => recipe.name }
  end

  content_type :json
  recipes.to_json
end

get '/order.json' do
  'order'

end

