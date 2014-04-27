require 'pry'

class QuotesController < Noodles::Http::Controller
  def a_quote
    @name = "Something pretty."
    @user_agent = request.user_agent
    render html: 'a_quote'
  end

  def erb
    @name = "Something pretty."
    @user_agent = request.user_agent
    render erb: 'a_quote'
  end

  def html
    @name = "Something pretty."
    @user_agent = request.user_agent
    render html: 'a_quote'
  end

  def slimmy
    render slim: 'slimmy'
  end

  def hamly
    render haml: 'hamly'
  end

  def text
    '<h1>No Quote</h1>'
  end

  def exception
    raise "It's a bad one!"
  end
end