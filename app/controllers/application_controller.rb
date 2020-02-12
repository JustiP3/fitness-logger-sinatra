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

    def find_workout(workout_id)
      @workout = Workout.find_by(:id => workout_id)
      if logged_in? && current_user.id == @workout.user_id
        @workout
      else
        redirect '/logout'
      end
    end
  end
end
