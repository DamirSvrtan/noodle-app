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

    Noodles.cache.set(session_id, {user_id: user.id, user_name: user.name})
    redirect_to '/'
  end

  private

    def session_id
      @env['rack.session']['session_id']
    end
end