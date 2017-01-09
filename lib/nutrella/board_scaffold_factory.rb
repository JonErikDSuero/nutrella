module Nutrella
  class BoardScaffold
    def initialize(filename)
      abort "the file for board scaffold is missing" unless File.exists?(filename)

      @filename = filename
    end
  end

  class NullBoardScaffold

  end

  module BoardScaffoldFactory
    def self.build(filename)
      if filename.present?
        BoardScaffold.new(filename)
      else
        NullBoardScaffold.new
      end
    end
  end
end
