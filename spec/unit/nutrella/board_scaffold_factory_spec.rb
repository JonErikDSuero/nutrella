RSpec.describe Nutrella::BoardScaffoldFactory do
  let(:path) { "path" }

  describe "#build" do
    it "returns null object when no file is provided" do
      board_scaffold = Nutrella::BoardScaffoldFactory.build(nil)

      expect(board_scaffold).to be_a(Nutrella::NullBoardScaffold)
    end

    it "errors when the given file is missing" do
      set_file_missing

      expect { Nutrella::BoardScaffoldFactory.build(path) }.to output(/the file for board scaffold is missing/)
        .to_stderr.and(raise_error(SystemExit))
    end
  end

  def set_file_missing
    allow(File).to receive(:exist?).with(path).and_return(false)
  end
end
