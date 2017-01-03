require "active_support/core_ext/string"

require "nutrella/board_skeleton"
require "nutrella/cache"
require "nutrella/command"
require "nutrella/configuration"
require "nutrella/developer_keys"
require "nutrella/task_board"
require "nutrella/task_board_name"
require "nutrella/version"

#
# A command line tool for associating a Trello board with the current git branch.
#
module Nutrella
  extend DeveloperKeys
end
