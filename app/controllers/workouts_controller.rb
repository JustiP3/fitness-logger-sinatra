class WorkoutsController < ApplicationController
  get '/workouts' do
    if logged_in?
      @workouts = current_user.workouts
      erb :'/workouts/index'
    else
      redirect '/logout'
    end
  end

  get '/workouts/new' do
    if logged_in?
      erb :'/workouts/new'
    else
      redirect '/logout'
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
      @error = "A workout needs BOTH a valid type AND either a duration, distance, or both distance and duration"
      erb :'/workouts/new'
    end
  end

  get '/workouts/:id/update' do
    @workout = find_workout(params[:id])
    if validate_workout_user(@workout)
      erb :'/workouts/update'
    else
      redirect 'logout'
    end
  end

  patch '/workouts/:id/update' do
    @workout = find_workout(params[:id])
    if validate_workout_user(@workout)
      updated_params = validate_workout(params[:workout])
      @workout.update(updated_params)
      @workout.save
      redirect "/workouts/#{@workout.id}"
    else
      redirect '/logout'
    end
  end

  delete '/workouts/:id/delete' do
    @workout = find_workout(params[:id])
    if validate_workout_user(@workout)
      @workout.delete
      redirect '/workouts/index'
    else
      redirect '/logout'
    end
  end

  get '/workouts/:id' do
    @workout = find_workout(params[:id])
    if validate_workout_user(@workout)
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
    #2. Validate - a workout needs a type and either duration or distance and a valid workout type
    valid = false
    valid_workout_type = false
    valid_duration_or_distance = false

    params[:workout_type] = params[:workout_type].downcase
    case params[:workout_type]
    when "run"
      params[:workout_type] = "Run"
      valid_workout_type = true
    when "walk"
      params[:workout_type] = "Walk"
      valid_workout_type = true
    when "bike"
      params[:workout_type] = "Bike"
      valid_workout_type = true
    when "swim"
      params[:workout_type] = "Swim"
      valid_workout_type = true
    when "hike"
      params[:workout_type] = "Hike"
      valid_workout_type = true
    else
      valid_workout_type = false
    end

    if (params[:duration] != "") || (params[:distance] != "")
      valid_duration_or_distance = true
    end

    if valid_workout_type && valid_duration_or_distance
      valid = true
      params[:pace] = "Cannot calculate pace"
    end
    #3. calculate pace if we have both duration and distance. Also strip any text charachters from distance and duration.
    if (params[:duration] != "") && (params[:distance] != "")
      params = calculate_pace(params)
    else
      params[:distance] = params[:distance].to_f.to_s
      params[:duration] = params[:duration].to_f.to_s
    end
    #4 return updated params if valid or nil
    if valid
      params
    else
      nil
    end
  end

  def calculate_pace(params)
    distance = params[:distance].to_f
    duration = params[:duration].to_f
    params[:distance] = distance.to_s
    params[:duration] = duration.to_s
    pace = nil
    if distance == 0 || duration == 0
      pace = "Cannot calculate pace"
    else
      pace = duration/distance
      pace = pace.to_s + " minutes/mile"
    end
    params[:pace] = pace
    params
  end
end
