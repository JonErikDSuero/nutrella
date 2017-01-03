require "trello"

module Nutrella
  #
  # Knows how to use the Trello API to create and lookup task boards.
  #
  class TaskBoard
    def initialize(configuration)
      Trello.configure do |trello_client|
        trello_client.consumer_key = configuration.fetch(:key)
        trello_client.consumer_secret = configuration.fetch(:secret)
        trello_client.oauth_token = configuration.fetch(:token)
        trello_client.oauth_token_secret = configuration.fetch(:secret)
      end

      @organization = configuration.fetch(:organization)
    end

    def lookup_or_create(board_name, board_skeleton)
      lookup(board_name) || create(board_name, board_skeleton)
    end

    private

    def lookup(board_name)
      matching_boards(board_name).find { |board| board.name == board_name }
    end

    def matching_boards(board_name)
      Trello::Action.search(board_name, modelTypes: "boards", board_fields: "all").fetch("boards", [])
    end

    def create(board_name, board_skeleton)
      board = create_board(board_name).tap { |board| make_team_visible(board) }
      apply_board_skeleton(board, board_skeleton) unless board_skeleton.blank?
      board
    end

    def apply_board_skeleton(board, board_skeleton)
      board.lists.each(&:close!)

      board_skeleton.values[:lists].each do |list_attr|
        list = Trello::List.create(list_attr.merge(board_id: board.id).except(:cards))

        create_cards(list.id, list_attr[:cards])
      end
    end

    def create_cards(list_id, cards)
      return if cards.blank?

      cards.each do |card_attr|
        Trello::Card.create(card_attr.merge(list_id: list_id))
      end
    end

    def create_board(board_name)
      Trello::Board.create(name: board_name, organization_id: @organization)
    end

    def make_team_visible(board)
      Trello.client.put("/boards/#{board.id}", "prefs/permissionLevel=org")
    end
  end
end
