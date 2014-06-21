Noodles.setup do |config|
  config.use_memached_as_session_storage = false
  config.cache_store_name = 'noodle_chat_app'
end