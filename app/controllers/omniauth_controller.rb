require 'pry'

class OmniauthController < Noodles::Http::Controller
  def failure
    haml :failure
  end

  def success
    case params['provider']
    when 'github'
      @name = env['omniauth.auth']['info']['nickname']
    when 'facebook'
      @name = env['omniauth.auth']['info']['name']
    end

    response.set_cookie "provider", params['provider']
    haml :success
  end
end
