require 'spec_helper'
require 'fbl/helpers/goal_scorers'
require 'model/player'

describe Fbl::GoalScorers do
  include_context :database

  subject { Object.new.extend(described_class) }

  context '#goal_scorers_by_team' do
    let(:arsenal_goal_scorers) { [{name: 'Theo Walcott', team: 'Arsenal'}, {name: 'Mesut Özil', team: 'Arsenal'}] }
    let(:chelsea_goal_scorers) { [{name: 'Eden Hazard', team: 'Chelsea'}, {name: 'Fernando Torres', team: 'Chelsea'}] }
    let(:man_utd_goal_scorers) { [{name: 'Juan Mata', team: 'Man Utd'}, {name: ' Wayne Rooney', team: 'Man Utd'}] }
    let(:all_goal_scorers) {arsenal_goal_scorers + chelsea_goal_scorers + man_utd_goal_scorers}

    before do
      Player.destroy_all
      Player.create(all_goal_scorers)
    end

    it 'returns goal scorers grouped by given teams' do
      expected_goal_scorers_by_team = [
          {'Arsenal' => ['Theo Walcott', 'Mesut Özil']},
          {'Man Utd' => ['Juan Mata', ' Wayne Rooney']}
      ]

      goal_scorers_by_team = subject.goal_scorers_by_team(['Arsenal', 'Man Utd'])
      expect(goal_scorers_by_team).to eq(expected_goal_scorers_by_team)
    end

  end

end

