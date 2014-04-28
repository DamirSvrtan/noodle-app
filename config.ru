require './config/application'

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

use Rack::ContentType

app.http_app.route do
  match "", "quotes#index"
  match "abc", "quotes#slimmy"
  match "hamly", "quotes#hamly"
  match "pipa/:id/slavina/:slavina_id", "quotes#hamly"
  match "sub-app", proc { |env| [200, {}, [env['PATH_INFO']]] }
  match "sub-app2", proc { [200, {}, ['ANOTHER SUB APP']] }
end

run app


# run BestQuotes::Application.new