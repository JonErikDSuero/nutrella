require "yaml"

module Nutrella
  class BoardSkeleton
    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def values
      YAML.load_file(filename).deep_symbolize_keys!
    end

    def blank?
      filename.blank?
    end
  end
end
