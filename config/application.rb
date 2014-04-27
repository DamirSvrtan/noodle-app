require 'noodles'
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "handlers")

require 'quotes_controller'
require 'home_controller'
require 'chat_handler'

module BestQuotes
  class Application < Noodles::Application
  end
end