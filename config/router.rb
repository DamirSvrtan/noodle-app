Noodles.http_app.routes do
  root_to 'home#index'
  get 'chat', 'chat#index'
  get "auth/:provider/callback", 'session#success'
  get "auth/failure", 'session#failure'
  get "logout", 'session#logout'
end