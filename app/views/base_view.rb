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
    Room.where(public: true).map do |room|
      {id: room.id, name: room.name}
    end.to_json
  end

  def default_room_messages
    Room.default_room.messages.last(15).map do |message|
      message.angular_hash
    end.to_json
  end

  def default_room_id
    default_room = Room.where(name: "DefaultRoom").first.id
  end

end