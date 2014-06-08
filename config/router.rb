Noodles.http_app.routes do
  root_to 'home#index'
  get 'chat', 'chat#index'
  get "auth/:provider/callback", 'session#success'
  get "auth/failure", 'session#failure'
  post "rooms", "rooms#create"
  delete "logout", 'session#logout'
end