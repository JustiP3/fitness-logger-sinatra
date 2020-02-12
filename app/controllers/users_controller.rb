class UsersController < ApplicationController


    get '/login' do
      erb :'/users/login'
    end

    get '/signup' do
      erb :'/users/signup'
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
        redirect '/users'
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
        redirect '/users'
      elsif User.find_by(:username => username)
        @error = "That username already exists"
        erb :signup
      else
        @error = "New accounts require a username and password"
        erb :signup
      end
    end

  get '/users' do
    if logged_in?
      @user = User.find_by(:id => session[:user_id])
      erb :'/users/index'
    else
      redirect '/login'
    end
  end

  get '/users/:id/update' do
    if logged_in?
      @user = current_user
      erb :'/users/update'
    else
      redirect '/logout'
    end
  end

  patch '/users/:id/update' do
    if validate_current_user(params)
      @user = current_user
      @user.username = params[:new_username] unless params[:new_username] == ""
      @user.save
      redirect '/users'
    else
      redirect 'logout'
    end
  end

  delete '/users/:id/delete' do
    if validate_current_user(params)
      @user = current_user
      @user.delete
      redirect '/logout'
    else
      redirect '/logout'
    end
  end
end
