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
    if authenticated?
      register_connection!
      OnlineUsersTracker[self] = current_user
      broadcast_but_self user_connected
    else
      close_websocket
    end
  end

  def on_close env
    unregister_connection!
    user = OnlineUsersTracker.delete(self)
    broadcast_but_self user_disconnected(user)
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
        room.users << current_user unless room.users.include?(current_user)
        mongo_message = room.messages.create! content: message.content, user_id: current_user_id, user_name: current_user_name
        broadcast new_message(mongo_message)
      else
        close_websocket
      end
    end

    def switch_public_room(message)
      room = Room.find_or_create_private_conversation(message.user_id, current_user_id)
      send_data switch_public_room_response(room)
    end

    def user_connected
      { user_name: current_user_name, user_id: current_user_id, action: USER_CONNECTED }.to_json
    end

    def user_disconnected(user)
      { user_name: user.name, user_id: user.id, action: USER_DISCONNECTED }.to_json
    end

    def new_message(mongo_message)
      { user_name: mongo_message.user_name, message: mongo_message.content, action: NEW_MESSAGE }.to_json
    end

    def switch_public_room_response(room)
      last_messages = room.messages.last(15).map do |message|
        message.angular_hash
      end
      { action: ROOM_MESSAGES ,messages: last_messages }.to_json
    end
end