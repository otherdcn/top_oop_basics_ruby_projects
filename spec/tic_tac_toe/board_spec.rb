require_relative '../../tic_tac_toe/lib/board'

describe Board do
  describe "#initialize" do
    subject(:board_init) { Board.new }

    let(:grid_attr) { board_init.instance_variable_get(:@grid) }
    let(:key_attr) { board_init.instance_variable_get(:@key) }

    it "initializes a class of type Board" do
      expect(board_init).to be_a(Board)
    end

    it "has two attributes of type Array" do
      expect(grid_attr && key_attr).to be_a(Array)
    end
  end

  describe "#mark" do
    subject(:board_obj) { described_class.new }
    let(:player_board_mark) { "x" }
    let(:coord_id) { "a" }
    let(:coord) { [0, 0] }

    before do
      allow(board_obj).to receive(:grid=)
    end

    it "changes the multi-dimensioanl array element" do
      board_obj.mark(player_board_mark, coord_id)

      expect(board_obj.grid[coord[0]][coord[1]]).to eq("x")
    end

    it "returns the multi-dimensioanl array co-ordinates" do
      return_coord = board_obj.mark(player_board_mark, coord_id)

      expect(return_coord).to eq(coord)
    end
  end
end

