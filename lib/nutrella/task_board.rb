module Nutrella
  class TaskBoard
    attr_accessor :board

    def initialize(configuration)
      TrelloWrapper.configure_client(configuration)

      @organization_id = configuration.fetch(:organization)
    end

    def lookup(name:)
      @board = matching_boards(name).find { |board| board.name == name }
    end

    def create(name:)
      @board = create_board(name).tap { |board| make_team_visible(board.id) }
    end

    def apply_board_scaffold(board_scaffold)

    end

    private

    def matching_boards(board_name)
      TrelloWrapper.search_boards(board_name)
    end

    def create_board(board_name)
      TrelloWrapper.create_board(name: board_name, organization_id: @organization_id)
    end

    def make_team_visible(board_id)
      TrelloWrapper.set_board_visible_to_organization(board_id)
    end
  end
end
