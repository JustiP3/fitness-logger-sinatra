class WorkoutsController < ApplicationController
  get '/workouts/index' do
    if logged_in?
      @workouts = current_user.workouts
      erb :'/workouts/index'
    else
      redirect '/logout'
    end
  end

  get '/workouts/new' do
    if !logged_in?
      redirect '/logout'
    else
      erb :'/workouts/new'
    end
  end

  post '/workouts/new' do
    if !logged_in?
      redirect '/logout'
    end
    updated_params = validate_workout(params)
    if updated_params
      @workout = Workout.new(updated_params)
      @workout.user = current_user
      if @workout.save
        erb :'/workouts/show'
      else
        @error = "Failed to save"
        erb :'/workouts/new'
      end
    else
      @error = "A workout needs a type and either a duration or distance or both"
      erb :'/workouts/new'
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

  def validate_workout(params)
    #1. If no name, add datetime title
    if params[:name] == ""
      time = Time.new
      params[:name] = time.strftime("%a-%m-%d-%Y")
    end
    #2. Validate - a workout needs either duration or distance
    valid = false
    if (params[:duration] != "") || (params[:distance] != "")
      valid = true
    end
    #3. calculate pace if we have both duration and distance
    if (params[:duration] != "") && (params[:distance] != "")
      params = calculate_pace(params)
    end
    #4 return updated params if valid or nil
    if valid
      params
    else
      nil
    end
  end

  def calculate_pace(params)
    # will need to parse strings. need to decide on input format
    params
  end
end
