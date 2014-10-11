class CreatePredictions < ActiveRecord::Migration
  def self.up
    create_table :predictions do |t|

      t.belongs_to :user
      t.datetime :kick_off
      t.string :home_team
      t.string :away_team
      t.integer :home_team_score
      t.integer :away_team_score
      t.string :goal_scorer
      t.timestamps
    end
  end

  def self.down
    drop_table :predictions
  end
end
