#require_relative '../tic_tac_toe/lib/tic_tac_toe'
require_relative '../../tic_tac_toe/lib/tic_tac_toe'

describe TicTacToe::Game do
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
      it "calls complete_round once" do
        expect(game_play).to receive(:complete_round).once
        game_play.play(1)
      end
    end

    context "when rounds is 3" do
      it "calls complete_round three times" do
        expect(game_play).to receive(:complete_round).exactly(3).times
        game_play.play(3)
      end
    end

    context "when rounds id 10" do
      it "calls complete_round ten times" do
        expect(game_play).to receive(:complete_round).exactly(10).times
        game_play.play(10)
      end
    end
  end

  describe "#complete_round" do
    subject(:game_complete_round) { TicTacToe::Game.new }
    let(:board_display) { game_complete_round.instance_variable_get(:@board) }

    before do
      allow(game_complete_round).to receive(:puts)
      allow(game_complete_round).to receive(:reset_round_state)
      allow(game_complete_round).to receive(:announce_round_winner)
      allow(game_complete_round).to receive(:fill_board_per_turn)
      allow(board_display).to receive(:combined_grids)
    end

    it "calls fill_board_per_turn 5 times for 3x3 board" do
      allow(game_complete_round).to receive(:fill_board_per_turn).exactly(5).times
      game_complete_round.complete_round(1)
    end

    it "sends combined_grids to board_display instance" do
      expect(board_display).to receive(:combined_grids).once
      game_complete_round.complete_round(1)
    end
  end
end
