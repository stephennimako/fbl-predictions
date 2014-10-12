require 'model/player'

Before do
  Player.destroy_all
  players = []
  (Fbl::Fixtures::UNSELECTED_TEAMS + Fbl::Fixtures::SELECTED_TEAMS).each do |team|
    2.times do |index|
      players << {team: team, name: "#{team} player #{index}"}
    end
  end
  Player.create(players)
end

