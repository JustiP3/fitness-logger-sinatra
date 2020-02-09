class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.string :workout_type
      t.string :duration
      t.string :distance
      t.string :pace
      t.integer :user_id
    end
  end
end
