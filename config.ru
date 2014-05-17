require './config/application'
require 'omniauth-facebook'
require 'omniauth-github'
use Rack::Session::Cookie, :secret => 'abc123'
use Rack::ShowExceptions

use OmniAuth::Builder do
  provider :facebook, '312961052192621', '9bbc99ea0fe36924939b5022743a6ea4'
  provider :github, '47a54178a58a310f0e03', '616480bca66a1b578cd0b9d847047365973cae03'
end

class BenchMarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end
  def call(env)
    t = Time.now
    result = nil
    @runs.times { result = @app.call(env) }
    t2 = Time.now - t
    STDERR.puts <<OUTPUT
Benchmark:
  #{@runs} runs
  #{t2.to_f} seconds total
  #{t2.to_f * 1000.0 / @runs} millisec/run
OUTPUT
result end
end

# use BenchMarker, 10_000

app = BestQuotes::Application.new

logger = $stdout
# File.open('log/dev.log', 'a+')
use Rack::CommonLogger, logger

use Rack::ContentType

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

# clogger = Rack::CommonLogger.new(app, logger)
run app


# run BestQuotes::Application.new