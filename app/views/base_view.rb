class BaseView
  include AuthHelper

  def users
    (User.all - [current_user]).map do |user|
      {id: user.id, name: user.name}
    end.to_json
  end

  def online_users
    (OnlineUsersTracker.online_users - [current_user]).map do |user|
      {id: user.id, name: user.name}
    end.to_json
  end

  def offline_users
    (OnlineUsersTracker.offline_users - [current_user]).map do |user|
      {id: user.id, name: user.name}
    end.to_json
  end

  def rooms
    Rooms.all.map do |room|
      {id: room.id, name: room.name}
    end.to_json
  end

end