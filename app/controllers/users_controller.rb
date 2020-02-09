class UsersController < ApplicationController
  get '/users/index' do
    if session[:user_id] && logged_in?
      erb :'/users/index'
    else
      redirect '/login'
    end
  end

end
