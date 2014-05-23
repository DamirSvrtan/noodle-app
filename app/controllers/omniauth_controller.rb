require 'pry'

class OmniauthController < Noodles::Http::Controller
  def failure
    haml :failure
  end

  def success
    info = env['omniauth.auth']['info']

    case params['provider']
    when 'github'
      @name = info['nickname']
    when 'facebook'
      @name = info['name']
    end

    response.set_cookie "provider", value: params['provider'], path: "/"

    user = User.first_or_create(name: @name, provider: params["provider"])
    redirect_to '/'
  end
end