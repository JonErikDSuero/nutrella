module Nutrella
  #
  # Utilities to allow a user to obtain their Trello API developer keys.
  #
  module DeveloperKeys
    def open_public_key_url
      TrelloWrapper.open_public_key_url
    end

    def open_authorization_url(options = {})
      TrelloWrapper.open_authorization_url(options.merge(name: "Nutrella"))
    end
  end
end
