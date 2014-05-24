Noodles.http_app.routes do
  root_to 'chat#index'
  get "auth/:provider/callback", 'session#success'
  get "auth/failure", 'session#failure'
end