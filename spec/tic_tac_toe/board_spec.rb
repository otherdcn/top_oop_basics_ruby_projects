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
end
