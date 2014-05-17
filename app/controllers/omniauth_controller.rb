require 'pry'

class OmniauthController < Noodles::Http::Controller
  def failure
    binding.pry
  end

  def success
    binding.pry
    puts params[:provider]
    @email = env['omniauth.auth']['info']['email']
    @name = env['omniauth.auth']['info']['name']
    render haml: :success
  end
end
