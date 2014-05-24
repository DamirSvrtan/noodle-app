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

  def info
    Noodles.cache.get(session_id)
  end

  def session_id
    @env['rack.session']['session_id']
  end
end