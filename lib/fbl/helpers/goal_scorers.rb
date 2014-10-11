require 'model/player'

module Fbl
  module GoalScorers

    def goal_scorers_by_team(teams)
      goal_scorers = []
      teams.each do |team|
        goal_scorer_in_team = Player.where(team: team).map do |goal_scorer_with_team|
          goal_scorer_with_team.name
        end
        goal_scorers << {team => goal_scorer_in_team}
      end
      goal_scorers
    end
  end
end