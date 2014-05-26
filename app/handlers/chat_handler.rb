require 'json'
class ChatHandler < Noodles::Websocket::Handler
  include AuthHelper

  def on_open env
    @env = env
    if authenticated?
      add_connection self
      OnlineUsersTracker[self] = current_user
      begin
        msg = { username: current_user_name, user_id: current_user_id, message: 'connected' }
        broadcast_but_self msg.to_json
      rescue => e
        binding.pry
      end
    else
      close_websocket
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
    user = OnlineUsersTracker.delete(self)
    msg = { username: user.name, user_id: user.id, message: 'disconnected' }
    broadcast_but_self msg.to_json
  end
end