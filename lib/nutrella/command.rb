module Nutrella
  #
  # This is the top-level class for the gem.
  #
  class Command
    def initialize(configuration_directory, board_name)
      @configuration_directory = configuration_directory
      @board_name = board_name
    end

    def run
      open board_url
    end

    def cache_filename
      File.join(@configuration_directory, ".nutrella.cache.yml")
    end

    def configuration_filename
      File.join(@configuration_directory, ".nutrella.yml")
    end

    private

    def board_url
      url_cache.fetch(@board_name) { task_board.lookup_or_create(@board_name).try(:url) }
    end

    def open(url)
      system("open #{url}") if url
    end

    def task_board
      TaskBoard.new(Configuration.new(configuration_filename))
    end

    def url_cache
      Cache.new(cache_filename, 5)
    end
  end
end
