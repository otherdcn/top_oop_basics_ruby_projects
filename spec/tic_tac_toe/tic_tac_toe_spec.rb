#require_relative '../tic_tac_toe/lib/tic_tac_toe'
require_relative '../../tic_tac_toe/lib/tic_tac_toe'

describe TicTacToe do
  describe "#initialize" do
    subject(:ttt_init) { TicTacToe::Game.new }

    let(:board_attr) { ttt_init.instance_variable_get(:@board) }
    let(:player_x_attr) { ttt_init..instance_variable_get(:@player_x) }
    let(:player_o_attr) { ttt_init.instance_variable_get(:@player_o) }

    it "initializes a TicTacToe class" do
      expect(ttt_init).to be_a(TicTacToe::Game)
    end

    it "has a board attribute of type Board" do
      expect(board_attr).to be_a(Board)
    end

    it "has two player attributes of type Player" do
      expect(player_x_attr && player_o_attr).to be_a(Player)
    end
  end

  describe "#play" do
    subject(:game_play) { TicTacToe::Game.new }

    before do
      allow(game_play).to receive(:puts)
      allow(game_play).to receive(:display_scoreboard)
    end

    context "when rounds is 1" do
      it "calls play_round once" do
        expect(game_play).to receive(:play_round).once
        game_play.play(1)
      end
    end

    context "when rounds is 3" do
      it "calls play_round three times" do
        expect(game_play).to receive(:play_round).exactly(3).times
        game_play.play(3)
      end
    end

    context "when rounds id 10" do
      it "calls play_round ten times" do
        expect(game_play).to receive(:play_round).exactly(10).times
        game_play.play(10)
      end
    end
  end
end
