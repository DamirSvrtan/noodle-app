require 'json'
class ChatHandler < Noodles::Websocket::Handler
  def on_open env
    add_connection self
    msg = { username: params(env)['username'], message: 'connected' }
    broadcast msg.to_json
  end

  def on_message env, msg
    broadcast msg
  end

  def on_close env
    remove_connection self
    msg = { username: params(env)['username'], message: 'disconnected' }
    broadcast msg.to_json
  end
end