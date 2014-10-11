require 'model/player'


Before do
  players = []
  (Fbl::Fixtures::UNSELECTED_TEAMS + Fbl::Fixtures::SELECTED_TEAMS).each do |team|
    4.times do |index|
      players << {team: team, name: "#{team} player #{index}"}
    end
  end
  Player.create(players)
end

After do
  Player.destroy_all
end
