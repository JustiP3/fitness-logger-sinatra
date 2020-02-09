require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get '/login' do

  end

  get '/signup' do

  end

  post '/login' do

  end

  post '/signup' do

  end

end
