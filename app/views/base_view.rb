class BaseView
  include AuthHelper
  def users
    (User.all - [current_user]).map do |user|
      {id: user.id, name: user.name}
    end.to_json
  end

  def online_users
    cached_sessions.values.map do |session_entry_value|
      {id: session_entry_value[:user_id], name: session_entry_value[:user_name]}
    end.to_json
  end
end