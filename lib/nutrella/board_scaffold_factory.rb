module Nutrella
  class BoardScaffold
    def initialize(path)
      abort "the file for board scaffold is missing" unless File.exists?(path)

      @path = path
    end

    def values
      @values = YAML.load_file(@path).deep_symbolize_keys!
    end
  end

  class NullBoardScaffold

  end

  module BoardScaffoldFactory
    def self.build(path)
      if path.present?
        BoardScaffold.new(path)
      else
        NullBoardScaffold.new
      end
    end
  end
end
