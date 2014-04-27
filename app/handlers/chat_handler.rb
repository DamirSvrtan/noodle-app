class ChatHandler < Noodles::Websocket::Handler
  def on_open env
    ChatChannel.connections << connection
    ChatChannel.broadcast "hello"
  end

  def on_message env, msg

  end

  def on_close env

  end
end