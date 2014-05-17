require './config/application'
require 'omniauth-facebook'
require 'omniauth-github'

use Rack::Session::Cookie, :secret => 'abc123'
use Rack::ShowExceptions
use Rack::CommonLogger, $stdout
use Rack::ContentType
use Rack::Static, urls: ["/css", "/images", "/js"], root: "public"

use OmniAuth::Builder do
  provider :facebook, ENV['NOODLE_FB_ID'], ENV['NOODLE_FB_SECRET']
  provider :github, ENV['NOODLE_GITHUB_ID'], ENV['NOODLE_GITHUB_SECRET']
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