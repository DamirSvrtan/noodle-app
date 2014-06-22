require 'json'
class ChatHandler < Noodles::Websocket::Handler
  include AuthHelper

  def on_open env
    if authenticated?
      register_connection!
      OnlineUsersTracker[self] = current_user
      msg = { user_name: current_user_name, user_id: current_user_id, message: 'connected' }
      broadcast_but_self msg.to_json
    else
      close_websocket
    end
  end

  def on_message env, msg
    newMessage = Room.where(name: "DefaultRoom").first.messages.create! content: msg, user_id: current_user_id, user_name: current_user_name
    broadcast newMessage.stringified_json
  end

  def on_close env
    unregister_connection!
    user = OnlineUsersTracker.delete(self)
    msg = { user_name: user.name, user_id: user.id, message: 'disconnected' }
    broadcast_but_self msg.to_json
  end
end