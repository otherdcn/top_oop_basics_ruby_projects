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

  describe "#row_check" do
    subject(:board_check) { described_class.new }

    context "when no row contains three sequential marks" do
      it do
        row_set = board_check.row_check("x")
        expect(row_set[:set_completed]).to eq false
      end
    end

    context "when one row contains three sequential marks(Xs or Os)" do
      before do
        board_check.grid = [["x", "x", "x"], [".", ".", "."], [".", ".", "."]]
      end

      it do
        row_set = board_check.row_check("x")
        expect(row_set[:set_completed]).to eq true
      end
    end
  end

  describe "#column_check" do
    subject(:board_check) { described_class.new }

    context "when no column contains three sequential marks" do
      it do
        column_set = board_check.column_check("x")
        expect(column_set[:set_completed]).to eq false
      end
    end

    context "when one column contains three sequential marks(Xs or Os)" do
      before do
        board_check.grid = [["x", ".", "."], ["x", ".", "."], ["x", ".", "."]]
      end

      it do
        column_set = board_check.column_check("x")
        expect(column_set[:set_completed]).to eq true
      end
    end
  end

  describe "#diagonal_check" do
    subject(:board_check) { described_class.new }

    context "when no diagonal contains three sequential marks" do
      it do
        diagonal_set = board_check.diagonal_check("x")
        expect(diagonal_set[:set_completed]).to eq false
      end
    end

    context "when one diagonal contains three sequential marks(Xs or Os)" do
      before do
        board_check.grid = [["x", ".", "."], [".", "x", "."], [".", ".", "x"]]
      end

      it do
        diagonal_set = board_check.diagonal_check("x")
        expect(diagonal_set[:set_completed]).to eq true
      end
    end
  end
end

