require 'noodles'
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "handlers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "channels")

require 'quotes_controller'
require 'home_controller'
require 'omniauth_controller'
require 'chat_handler'
require 'chat_channel'

module BestQuotes
  class Application < Noodles::Application
  end
end