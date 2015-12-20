require File.dirname(__FILE__) + '/spec_helper'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'  # <-- your sinatra app

describe 'The calculate food order site ' do

  def app
    Sinatra::Application
  end

  it "shows the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end

  it "returns the appropriate unit if I send a recipe's ingredient" do
    get '/order'
    expect(last_response).to be_ok
    #expect(last_response).to re
  end
end
