require './config/application'
require './config/router'
require 'omniauth-facebook'
require 'omniauth-github'

use Rack::Session::Cookie, :secret => 'abc123'
use Rack::ShowExceptions if Noodles.env.development?
use Rack::CommonLogger, $stdout
use Rack::ContentType
use Rack::Static, urls: ["/css", "/images", "/js", "/favicon.ico"], root: "public"

use OmniAuth::Builder do
  provider :facebook, ENV['NOODLE_FB_ID'], ENV['NOODLE_FB_SECRET']
  provider :github, ENV['NOODLE_GITHUB_ID'], ENV['NOODLE_GITHUB_SECRET']
end

run Noodles.application