require 'json'
class ChatHandler < Noodles::Websocket::Handler
  include AuthHelper

  def on_open env
    @env = env
    if authenticated?
      add_connection self
      msg = { username: current_user_name, user_id: current_user_id, message: 'connected' }
      broadcast_but_self msg.to_json
    end
  end

  def on_message env, msg
    @env = env
    msg = { username: current_user_name, message: msg }
    broadcast msg.to_json
  end

  def on_close env
    @env = env
    remove_connection self
    msg = { username: current_user_name, user_id: current_user_id, message: 'disconnected' }
    broadcast_but_self msg.to_json
  end
end