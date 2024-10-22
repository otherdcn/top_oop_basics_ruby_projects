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

  describe "#prompt_user_input" do
    subject(:game_player_input) { described_class.new }
    let(:player) { game_player_input.player_x }
    let(:points_marked) { ["d", "h", "b"] }

    describe "invalid input attempts" do
      context "when first input attempt is valid" do
        before do
          valid_input = "a"
          allow(game_player_input).to receive(:gets).and_return(valid_input)
          allow(game_player_input).to receive(:print)
        end

        it "completes loop and displays prompt message once" do
          expect(game_player_input).to receive(:print).once
          game_player_input.prompt_user_input(player, points_marked)
        end
      end

      context "when first input attempt is invalid, then a valid second input" do
        before do
          invalid_input = "p"
          valid_input = "a"
          allow(game_player_input).to receive(:gets).and_return(invalid_input, valid_input)
          allow(game_player_input).to receive(:print)
          allow(game_player_input).to receive(:puts).with("Input not between A-I/a-i. Try again")
        end

        it 'completes loop and displays prompt message twice' do
          expect(game_player_input).to receive(:print).twice
          game_player_input.prompt_user_input(player, points_marked)
        end
      end

      context "when first 4 input attempts are invlaid, then a valid 5th input" do
        before do
          invalid_input_1 = "r"
          invalid_input_2 = "u"
          invalid_input_3 = "m"
          invalid_input_4 = "p"
          valid_input = "a"
          allow(game_player_input).to receive(:gets).and_return(invalid_input_1,
                                                                invalid_input_2,
                                                                invalid_input_3,
                                                                invalid_input_4,
                                                                valid_input)
          allow(game_player_input).to receive(:print)
          allow(game_player_input).to receive(:puts).with("Input not between A-I/a-i. Try again")
        end

        it 'completes loop and displays prompt message five times' do
          expect(game_player_input).to receive(:print).exactly(5).times
          game_player_input.prompt_user_input(player, points_marked)
        end
      end
    end

    describe "unavailable input attempts" do
      context "when first input attempt is unavailable" do
         before do
          available_input = "a"
          allow(game_player_input).to receive(:gets).and_return(available_input)
          allow(game_player_input).to receive(:print)
        end

        it "completes loop and displays prompt message once" do
          expect(game_player_input).to receive(:print).once
          game_player_input.prompt_user_input(player, points_marked)
        end
      end

      context "when first input attempt is unavailable, then an available second input" do
        before do
          unavailable_input = points_marked[0]
          available_input = "a"
          allow(game_player_input).to receive(:gets).and_return(unavailable_input, available_input)
          allow(game_player_input).to receive(:print)
          allow(game_player_input).to receive(:puts).with("Point arleady marked. Try again!")
        end

        it 'completes loop and displays prompt message twice' do
          expect(game_player_input).to receive(:print).twice
          game_player_input.prompt_user_input(player, points_marked)
        end
      end

      context "when first 3 input attempts are unavailable, then an available 4th input" do
        before do
          unavailable_input_1 = points_marked[0]
          unavailable_input_2 = points_marked[1]
          unavailable_input_3 = points_marked[2]
          available_input = "a"
          allow(game_player_input).to receive(:gets).and_return(unavailable_input_1,
                                                                unavailable_input_2,
                                                                unavailable_input_3,
                                                                available_input)
          allow(game_player_input).to receive(:print)
          allow(game_player_input).to receive(:puts).with("Point arleady marked. Try again!")
        end

        it 'completes loop and displays prompt message four times' do
          expect(game_player_input).to receive(:print).exactly(4).times
          game_player_input.prompt_user_input(player, points_marked)
        end
      end
    end
  end
end
