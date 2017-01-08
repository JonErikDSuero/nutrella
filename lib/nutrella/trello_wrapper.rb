require "trello"

module Nutrella
  #
  # Knows how to use the Trello API
  #
  module TrelloWrapper
    def self.open_public_key_url
      Trello.open_public_key_url
    end

    def self.open_authorization_url(options)
      Trello.open_authorization_url(options)
    end

    def self.configure_client(configuration)
      Trello.configure do |trello_client|
        trello_client.consumer_key = configuration.fetch(:key)
        trello_client.consumer_secret = configuration.fetch(:secret)
        trello_client.oauth_token = configuration.fetch(:token)
        trello_client.oauth_token_secret = configuration.fetch(:secret)
      end
    end

    def self.search_boards(board_name)
      Trello::Action.search(board_name, modelTypes: "boards", board_fields: "all").fetch("boards", [])
    end

    def self.create_board(name:, organization_id:)
      Trello::Board.create(name: name, organization_id: organization_id)
    end

    def self.set_board_visible_to_organization(board_id)
      Trello.client.put("/boards/#{board_id}", "prefs/permissionLevel=org")
    end
 end
end

