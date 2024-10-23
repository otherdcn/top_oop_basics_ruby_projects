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
    let(:coord_ids_marked) { ["d", "h", "b"] }

    describe "invalid input attempts" do
      context "when first input attempt is valid" do
        before do
          valid_input = "a"
          allow(game_player_input).to receive(:gets).and_return(valid_input)
          allow(game_player_input).to receive(:print)
        end

        it "completes loop and displays prompt message once" do
          expect(game_player_input).to receive(:print).once
          game_player_input.prompt_user_input(player, coord_ids_marked)
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
          game_player_input.prompt_user_input(player, coord_ids_marked)
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
          game_player_input.prompt_user_input(player, coord_ids_marked)
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
          game_player_input.prompt_user_input(player, coord_ids_marked)
        end
      end

      context "when first input attempt is unavailable, then an available second input" do
        before do
          unavailable_input = coord_ids_marked[0]
          available_input = "a"
          allow(game_player_input).to receive(:gets).and_return(unavailable_input, available_input)
          allow(game_player_input).to receive(:print)
          allow(game_player_input).to receive(:puts).with("Point arleady marked. Try again!")
        end

        it 'completes loop and displays prompt message twice' do
          expect(game_player_input).to receive(:print).twice
          game_player_input.prompt_user_input(player, coord_ids_marked)
        end
      end

      context "when first 3 input attempts are unavailable, then an available 4th input" do
        before do
          unavailable_input_1 = coord_ids_marked[0]
          unavailable_input_2 = coord_ids_marked[1]
          unavailable_input_3 = coord_ids_marked[2]
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
          game_player_input.prompt_user_input(player, coord_ids_marked)
        end
      end
    end
  end

  describe "#fill_board_per_turn" do
    subject(:game_fill_board) { described_class.new }
    let(:board_display) { game_fill_board.board }
    let(:coord_ids_marked) { ["d", "h", "b"] }
    let(:coord_point_marked) { [0,0] }

    before do
      allow(game_fill_board).to receive(:prompt_user_input).and_return("a")
      allow(board_display).to receive(:mark).and_return(coord_point_marked)
      allow(board_display).to receive(:combined_grids)
    end

    context "when winner is found during current turn" do
      before do
        allow(game_fill_board).to receive(:check_if_three).and_return({
          set_completed: true,
          winning_coords: [[0,0], [0,1], [0,2]]
        })
      end

      it "round_winner is set to current player" do
        game_fill_board.fill_board_per_turn(coord_ids_marked)
        expect(game_fill_board.round_winner).to_not be_nil
      end

      it "returns an array of winning points" do
        winning_coords = game_fill_board.fill_board_per_turn(coord_ids_marked)
        expect(winning_coords).to eq([[0,0], [0,1], [0,2]])
      end
    end

    context "when no winner is found during current turn" do
      before do
        allow(game_fill_board).to receive(:check_if_three).and_return({
          set_completed: false,
          winning_coords: nil
        })
      end

      it "round_winner remains nil" do
        game_fill_board.fill_board_per_turn(coord_ids_marked)
        expect(game_fill_board.round_winner).to be_nil
      end

      it "returns an empty array" do
        winning_coords = game_fill_board.fill_board_per_turn(coord_ids_marked)
        expect(winning_coords).to eq([])
      end
    end

    it "send combined_grids to board" do
      expect(board_display).to receive(:combined_grids).with(coord_point_marked)
      game_fill_board.fill_board_per_turn(coord_ids_marked)
    end
  end

  describe "#check_if_three" do
    subject(:game_set_check)      { described_class.new }
    let(:board_check)             { game_set_check.board }

    let(:complete_row_set)        { { set_completed: true, winning_coords: [[1,0], [1,1], [1,2]] } }
    let(:complete_column_set)     { { set_completed: true, winning_coords: [[0,1], [1,1], [2,1]] } }
    let(:complete_diagonal_set)   { { set_completed: true, winning_coords: [[2,0], [1,1], [0,1]] } }
    let(:incomplete_set)          { { set_completed: false, winning_coords: [] } }
    let(:player) { game_set_check.player_x }

    context "when sending outgoing messages" do
      context "board_check" do
        before do
          allow(board_check).to receive(:row_check).and_return(complete_row_set)
        end

        it do
          expect(board_check).to receive(:row_check).twice
          game_set_check.check_if_three(player)
        end
      end

      context "board_check" do
        before do
          allow(board_check).to receive(:column_check).and_return(complete_column_set)
        end

        it do
          expect(board_check).to receive(:column_check).twice
          game_set_check.check_if_three(player)
        end
      end

      context "board_check" do
        before do
          allow(board_check).to receive(:diagonal_check).and_return(complete_diagonal_set)
        end

        it do
          expect(board_check).to receive(:diagonal_check).twice
          game_set_check.check_if_three(player)
        end
      end
    end

    context "when there is a complete set" do
      before do
        allow(board_check).to receive(:column_check).and_return(complete_column_set)
      end

      it "returns a hash with set_completed set to true" do
        game_set_check.check_if_three(player) => set_completed: set_completed
        expect(set_completed).to be true
      end

      it "returns a hash with an array of a complete co-ordinate set" do
        game_set_check.check_if_three(player) => winning_coords: winning_coords
        expect(winning_coords).to_not be_empty
      end
    end

    context "when there is no complete set" do
      before do
        allow(board_check).to receive(:diagonal_check).and_return(incomplete_set)
      end

      it "returns a hash with set_completed set to false" do
        game_set_check.check_if_three(player) => set_completed: set_completed
        expect(set_completed).to be false
      end

      it "returns a hash with an empty co-ordinates array" do
        game_set_check.check_if_three(player) => winning_coords: winning_coords
        expect(winning_coords).to be_empty
      end
    end
  end
end

