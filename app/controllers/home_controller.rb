class HomeController < BaseController

  def index
    if signed_in?
      redirect_to '/chat'
    else
      slim :index
    end
  end


end