require './config/application'
require 'omniauth-facebook'
require 'omniauth-github'

use Rack::Session::Cookie, :secret => 'abc123'
use Rack::ShowExceptions
use Rack::CommonLogger, $stdout
use Rack::ContentType

use OmniAuth::Builder do
  provider :facebook, '312961052192621', '9bbc99ea0fe36924939b5022743a6ea4'
  provider :github, '47a54178a58a310f0e03', '616480bca66a1b578cd0b9d847047365973cae03'
end

app = BestQuotes::Application.new

app.http_app.routes do
  get "", "quotes#index"
  get "abc", "quotes#slimmy"
  get "hamly", "quotes#hamly"
  get "pipa/:id/slavina/:slavina_id", "quotes#hamly"
  get "sub-app", proc { |env| [200, {}, [env['PATH_INFO']]] }
  get "sub-app2", proc { [200, {}, ['ANOTHER SUB APP']] }
  get "auth/:provider/callback", 'omniauth#success'
  get "auth/failure", 'omniauth#failure'
end

run app