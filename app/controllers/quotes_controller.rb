require 'pry'
class QuotesController < Noodles::Controller
  def a_quote
    @name = "Something pretty."
    @user_agent = request.user_agent
    render 'a_quote'
  end

  def exception
    raise "It's a bad one!"
  end
end