require_relative '../../tic_tac_toe/lib/player'

describe Player do
  describe "#initialize" do
    subject(:player_init) { Player.new("Player X", "X") }

    let(:name_attr) { player_init.instance_variable_get(:@name) }
    #let(:board_mark_attr) { player_init.instance_variable_get(:@board_mark) }
    let(:score_attr) { player_init.instance_variable_get(:@score) }

    it "initializes a class of type Player" do
      expect(player_init).to be_a(Player)
    end

    it "has an attribute of type Integer" do
      expect(score_attr).to be_a(Integer)
    end
  end
end
