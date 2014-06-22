require 'json'
class ChatHandler < Noodles::Websocket::Handler
  include AuthHelper

  USER_CONNECTED = 1;
  USER_DISCONNECTED = 2;
  NEW_MESSAGE = 3;

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
    mongo_message = Room.where(name: "DefaultRoom").first.messages.create! content: msg, user_id: current_user_id, user_name: current_user_name
    broadcast new_message(mongo_message)
  end

  private

    def user_connected
      { user_name: current_user_name, user_id: current_user_id, action: USER_CONNECTED }.to_json
    end

    def user_disconnected(user)
      { user_name: user.name, user_id: user.id, action: USER_DISCONNECTED }.to_json
    end

    def new_message(mongo_message)
      { user_name: mongo_message.user_name, message: mongo_message.content, action: NEW_MESSAGE }.to_json
    end
end