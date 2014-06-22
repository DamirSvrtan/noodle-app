require 'json'
class ChatHandler < Noodles::Websocket::Handler
  include AuthHelper

  USER_CONNECTED = 1
  USER_DISCONNECTED = 2
  NEW_MESSAGE = 3
  SWITCH_PUBLIC_ROOM = 4
  SWITCH_PRIVATE_ROOM = 5
  ROOM_MESSAGES = 6

  def on_open env
    begin
      if authenticated?
        register_connection!
        OnlineUsersTracker[self] = current_user
        broadcast_but_self user_connected
      else
        close_websocket
      end
    rescue => e
      binding.pry
    end
  end

  def on_close env
    begin
      unregister_connection!
      user = OnlineUsersTracker.delete(self)
      broadcast_but_self user_disconnected(user)
    rescue => e
      binding.pry
    end
  end

  def on_message env, msg
    begin
      message = OpenStruct.new(JSON.parse(msg))
      case message.action
      when NEW_MESSAGE
        publish_new_message(message)
      when SWITCH_PUBLIC_ROOM
        switch_public_room(message)
      when SWITCH_PRIVATE_ROOM
        switch_private_room(message)
      end
    rescue => e
      binding.pry
    end
  end

  private

    def publish_new_message(message)
      room = Room.find(message.room_id)
      if room and room.public?
        publish_new_public_message(message, room)
      elsif room and room.users.include? current_user
        publish_new_private_message(message, room)
      else
        close_websocket
      end
    end

    def publish_new_public_message(message, room)
      room.users << current_user unless room.users.include?(current_user)
      mongo_message = room.messages.create! content: message.content, user_id: current_user_id, user_name: current_user_name
      broadcast new_message(mongo_message)
    end

    def publish_new_private_message(message, room)
      mongo_message = room.messages.create! content: message.content, user_id: current_user_id, user_name: current_user_name
      room.users.each do |user|
        user_connection = OnlineUsersTracker.get_connection(user)
        user_connection && user_connection.send_data(new_message(mongo_message))
      end
    end

    def switch_public_room(message)
      room = Room.find(message.room_id)
      send_data switch_room_response(room)
    end

    def switch_private_room(message)
      room = Room.find_or_create_private_conversation(message.user_id, current_user_id)
      send_data switch_room_response(room, message.user_id)
    end

    def user_connected
      { user_name: current_user_name, user_id: current_user_id, action: USER_CONNECTED }.to_json
    end

    def user_disconnected(user)
      { user_name: user.name, user_id: user.id, action: USER_DISCONNECTED }.to_json
    end

    def new_message(mongo_message)
      { user_name: mongo_message.user_name,
        message: mongo_message.content,
        room_id: mongo_message.room.id,
        action: NEW_MESSAGE }.to_json
    end

    def switch_room_response(room, other_user_id=nil)
      last_messages = room.messages.last(15).map do |message|
        message.angular_hash
      end

      room_name = other_user_id.nil? ? room.name : User.find(other_user_id).name

      { action: ROOM_MESSAGES,
        messages: last_messages,
        room_id: room.id,
        room_name: room_name }.to_json
    end
end