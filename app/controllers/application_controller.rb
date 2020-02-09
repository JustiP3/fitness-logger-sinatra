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

  get '/home' do
    if logged_in?
      redirect '/users/index'
    else
      redirect '/'
    end
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
    if password != "" && username != "" && !User.find_by(:username => username)
      user = User.new(params)
      user.save
      session[:user_id] = user.id
      redirect '/users/index'
    elsif User.find_by(:username => username)
      @error = "That username already exists"
      erb :signup
    else
      @error = "New accounts require a username and password"
      erb :signup
    end
  end

  helpers do
    def logged_in?
      if session[:user_id] && current_user.id == session[:user_id]
        true
      else
        false
      end
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
