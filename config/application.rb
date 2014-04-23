require 'noodles'
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
module BestQuotes
  class Application < Noodles::Application
  end
end