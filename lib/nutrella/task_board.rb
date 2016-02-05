require "trello"

module Nutrella
  #
  # Knows the Trello API for creating and finding task boards.
  #
  class TaskBoard
    attr_reader :name

    def initialize(board_name, configuration)
      @name = board_name

      configuration.apply
    end

    def create
      Trello::Board.create(name: name)
    end

    def find
      results = Trello::Action.search(name, modelTypes: "boards", board_fields: "name,url")

      results["boards"].find { |board| board.name == name }
    end
  end
end
