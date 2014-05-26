module AuthHelper
  def current_user
    if signed_in?
      User.find(info[:user_id])
    end
  end

  def current_user_name
    info[:user_name]
  end

  def current_user_id
    info[:user_id]
  end

  def signed_in?
    info && info[:user_id]
  end

  alias_method :authenticated?, :signed_in?

  def info
    cached_sessions[session_id]
  end

  def session_id
    @env['rack.session']['init'] = true unless @env['rack.session'].loaded?
    @env['rack.session']['session_id']
  end

  def sign_out
    sessions = cached_sessions
    sessions.delete(session_id)
    Noodles.cache.set(:sessions, sessions)
  end

  def sign_in(user)
    sessions = cached_sessions
    sessions[session_id] = { user_id: user.id, user_name: user.name }
    Noodles.cache.set(:sessions, sessions)
  end

  def cached_sessions
    Noodles.cache.get(:sessions) || {}
  end
end