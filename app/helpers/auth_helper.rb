module AuthHelper
  def current_user
    if signed_in?
      User.find(session[:user_id])
    end
  end

  def session
    @env['rack.session']
  end

  def current_user_name
    session[:user_name]
  end

  def current_user_id
    session[:user_id]
  end

  def signed_in?
    !!session[:user_id]
  end

  alias_method :authenticated?, :signed_in?

  def session_id
    @env['rack.session']['init'] = true unless @env['rack.session'].loaded?
    @env['rack.session']['session_id']
  end

  def sign_out
    session.delete(:user_id)
    session.delete(:user_name)
  end

  def sign_in(user)
    session[:user_id] = user.id
    session[:user_name] = user.name
  end
end