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
      match "sub-app",
        proc { [200, {}, ["Hello, sub-app!"]] }
      # default routes
      match ":controller/:id/:action"
      match ":controller/:id",
        :default => { "action" => "show" }
      match ":controller",
        :default => { "action" => "index" }
    end

run app


# run BestQuotes::Application.new