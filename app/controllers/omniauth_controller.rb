require 'pry'

class OmniauthController < Noodles::Http::Controller
  def failure
    render haml: :failure
  end

  def success
    case params['provider']
    when 'github'
      @name = env['omniauth.auth']['info']['nickname']
    when 'facebook'
      @name = env['omniauth.auth']['info']['name']
    end
    render haml: :success
  end
end
