class WorkoutsController < ApplicationController
  get '/workouts/index' do
    if session[:user_id] && logged_in?
      @workouts = current_user.workouts
      erb :'/workouts/index'
    else
      redirect '/logout'
    end
  end

  get '/workouts/:id' do
    @workout = Workout.find_by(:id => params[:id])
    if session[:user_id] && logged_in? && @workout.user_id == session[:user_id]
      erb :'/workouts/show'
    else
      redirect '/logout'
    end
  end
end
