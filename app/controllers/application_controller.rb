require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get "/" do
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/signup' do
    erb :signup
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  post '/login' do
    username = params[:username]
    password = params[:password]
    user = User.find_by(:username => username)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect '/users/index'
    else
      redirect '/login'
    end
  end

  post '/signup' do
    username = params[:username]
    password = params[:password]
    if password != "" && username != ""
      user = User.new(params)
      if user.save
        session[:user_id] = user.id
        redirect '/users/index'
      else
        @error = "did not save"
        erb :error
      end
    else
      redirect '/signup'
    end
  end

  helpers do
    def logged_in?
      current_user.id == session[:user_id]
    end

    def current_user
      if session[:user_id]
        @current_user = User.find_by(id: session[:user_id])
      else
        nil
      end
    end
  end
end
