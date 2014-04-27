class ChatHandler < Noodles::Websocket::Handler
  def on_open env
    puts "TU SAM"
  end

  def on_message env, msg

  end

  def on_close env

  end
end