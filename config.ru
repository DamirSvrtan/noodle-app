require './config/init'
require 'omniauth-facebook'
require 'omniauth-github'

use Rack::Session::Cookie, secret: Noodles.secrets.session_secret
use Rack::ShowExceptions if Noodles.env.development?
use Rack::CommonLogger, $stdout
use Rack::ContentType
use Rack::MethodOverride
use Rack::Static, urls: ["/css", "/images", "/js", "/favicon.ico"], root: "public"

use OmniAuth::Builder do
  provider :facebook, Noodles.secrets.facebook_id, Noodles.secrets.facebook_secret
  provider :github, Noodles.secrets.github_id, Noodles.secrets.github_secret
end

run Noodles.application