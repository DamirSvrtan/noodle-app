class BaseController < Noodles::Http::Controller
  include AuthHelper
  view BaseView
end