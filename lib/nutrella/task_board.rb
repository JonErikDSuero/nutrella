module Nutrella
  class TaskBoard
    def initialize(configuration)
      TrelloWrapper.configure_client(configuration)

      @organization_id = configuration.fetch(:organization)
    end

    def lookup_or_create(board_name)
      lookup(board_name) || create(board_name)
    end

    private

    def lookup(board_name)
      matching_boards(board_name).find { |board| board.name == board_name }
    end

    def matching_boards(board_name)
      TrelloWrapper.search_boards(board_name)
    end

    def create(board_name)
      create_board(board_name).tap { |board| make_team_visible(board.id) }
    end

    def create_board(board_name)
      TrelloWrapper.create_board(name: board_name, organization_id: @organization_id)
    end

    def make_team_visible(board_id)
      TrelloWrapper.set_board_visible_to_organization(board_id)
    end
  end
end
