require File.dirname(__FILE__) + '/spec_helper'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'  # <-- your sinatra app

describe 'The calculate food order site ' do

  before(:each) do
    Recipe.all.destroy
  end

  def app
    Sinatra::Application
  end

  it "shows the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end

  it "should return all recipes" do
    Recipe.create(:name => 'Pfannkuchen')
    Recipe.create(:name => 'Ruehrei')

    get '/recipes.json'
    expect(last_response).to be_ok

    recipes = JSON::parse(last_response.body)
    expect(recipes.size).to be 2
    expect(recipes[0]['name']).to eq("Pfannkuchen")
    expect(recipes[1]['name']).to eq("Ruehrei")
  end

  it "should calculate an order for a recipe" do
    get '/order.json'

    expect(last_response).to be_ok
  end
end
