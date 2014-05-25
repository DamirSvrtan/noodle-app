module AuthHelper
  def current_user
    if signed_in?
      User.find(info[:user_id])
    end
  end

  def current_user_name
    info[:user_name]
  end

  def signed_in?
    info && info[:user_id]
  end

  alias_method :authenticated?, :signed_in?

  def info
    Noodles.cache.get(session_id)
  end

  def session_id
    @env['rack.session']['init'] = true unless @env['rack.session'].loaded?
    @env['rack.session']['session_id']
  end

  def sign_out
    Noodles.cache.delete(session_id)
  end

  def sign_in(user)
    Noodles.cache.set(session_id, { user_id: user.id, user_name: user.name })
  end
end