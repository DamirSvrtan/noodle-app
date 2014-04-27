class ChatHandler < Noodles::Websocket::Handler
  def on_open env
    add_connection self
    broadcast "hello"
  end

  def on_message env, msg

  end

  def on_close env
    remove_connection self
  end
end