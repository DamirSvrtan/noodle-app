Noodles.http_app.routes do
  root_to 'quotes#slimmy'
  get "hamly", "quotes#hamly"
  get "pipa/:id/slavina/:slavina_id", "quotes#hamly"
  get "sub-app", proc { |env| [200, {}, [env['PATH_INFO']]] }
  get "sub-app2", proc { [200, {}, ['ANOTHER SUB APP']] }
  get "auth/:provider/callback", 'omniauth#success'
  get "auth/failure", 'omniauth#failure'
end