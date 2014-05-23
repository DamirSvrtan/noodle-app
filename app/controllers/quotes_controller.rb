require 'pry'

class QuotesController < Noodles::Http::Controller
  view ApplicationView

  def a_quote
    @name = "Something pretty."
    @user_agent = request.user_agent
    html 'a_quote'
  end

  def erb
    @name = "Something pretty."
    @user_agent = request.user_agent
    erb 'a_quote'
  end

  def html
    @name = "Something pretty."
    @user_agent = request.user_agent
    html 'a_quote'
  end

  def slimmy
    slim 'slimmy'
  end

  def hamly
    haml 'hamly'
  end

  def index
    text "HEEEEY"
  end

  def text
    text '<h1>No Quote</h1>'
  end

  def exception
    raise "It's a bad one!"
  end
end