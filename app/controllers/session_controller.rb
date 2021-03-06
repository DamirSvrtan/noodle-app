require 'pry'

class SessionController < BaseController

  def success
    info = env['omniauth.auth']['info']

    case params['provider']
    when 'github'
      @name = info['nickname']
    when 'facebook'
      @name = info['name']
    end

    # response.set_cookie "provider", value: params['provider'], path: "/"
    user = User.where(name: @name, provider: params['provider']).first_or_create

    sign_in(user)

    redirect_to '/'
  end

  def failure
    haml :failure
  end

  def logout
    sign_out
    redirect_to '/'
  end
end