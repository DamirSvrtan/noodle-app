require 'pry'

class ChatController < BaseController
  def index
    slim :index
  end
end