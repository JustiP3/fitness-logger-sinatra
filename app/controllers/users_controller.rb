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
    if logged_in?
      @user = current_user
      erb :'/users/update'
    else
      redirect '/logout'
    end
  end

  patch '/users/:id/update' do
    @user = current_user
    @user.username = params[:new_username] unless params[:new_username] == ""
    @user.save
    redirect '/users/index'
  end

end
