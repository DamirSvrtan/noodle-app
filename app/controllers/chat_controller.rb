require 'pry'

class ChatController < BaseController
  def index
    return redirect_to "/" unless signed_in?
    slim :index
  end
end