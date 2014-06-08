require 'noodles'
require 'mongoid'
require 'pry'

mongo_yml_path = File.expand_path '../mongoid.yml', __FILE__

Mongoid.load!(mongo_yml_path, :development)

require_relative 'router'
require_relative 'setup'

%w(models helpers views controllers handlers channels).each do |app_folder|
  app_folder_path = File.join(File.dirname(__FILE__), "..", "app", app_folder)
  $LOAD_PATH << app_folder_path
  Dir[File.join(app_folder_path, "*.rb")].each {|file| require file }
end