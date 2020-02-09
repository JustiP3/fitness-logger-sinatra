class UsersController < ApplicationController
  get '/users/index' do
    if session[:user_id] && logged_in?
      @user = User.find_by(:id => session[:user_id])
      erb :'/users/index'
    else
      redirect '/login'
    end
  end

  get '/users/:id/update' do
    if params[:id] == session[:user_id]
      @user = User.find_by(:id => params[:id])
      erb :'/users/update'
    else
      redirect '/logout'
    end
  end

  post '/users/:id/update' do
    @user = User.find_by(:id => params[:id])
    @user.username = params[:new_username] unless params[:new_username] == ""
    @user.save
    redirect '/users/index'
  end

end
