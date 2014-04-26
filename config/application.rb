require 'noodles'
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")

require 'quotes_controller'
require 'home_controller'

module BestQuotes
  class Application < Noodles::Application
  end
end