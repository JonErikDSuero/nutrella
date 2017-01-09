module Nutrella
  #
  # This is the top-level class for the gem.
  #
  class Command
    attr_reader :board_scaffold_filename, :cache_filename, :configuration_filename

    def initialize(configuration_directory, board_name, board_scaffold_filename = nil)
      @board_name = board_name
      @board_scaffold_filename = board_scaffold_filename
      @cache_filename = File.join(configuration_directory, ".nutrella.cache.yml")
      @configuration_filename = File.join(configuration_directory, ".nutrella.yml")
    end

    def run
      open board_url
    end

    private

    def board_url
      url_cache.fetch(@board_name) { lookup_or_create_board.url }
    end

    def lookup_or_create_board
      lookup_board || create_board
    end

    def lookup_board
      task_board.lookup(name: @board_name)
    end

    def create_board
      task_board.create(name: @board_name)
    end

    def open(url)
      system("open #{url}")
    end

    def task_board
      TaskBoard.new(Configuration.values(configuration_filename))
    end

    def url_cache
      Cache.new(cache_filename, 5)
    end
  end
end
