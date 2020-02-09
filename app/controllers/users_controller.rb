class UsersController < ApplicationController
  get '/users/index' do
    if logged_in?
      erb :'/users/index'
    else
      redirect '/login'
    end
  end

end
