class BaseView
  include AuthHelper
  def users
    User.all - [current_user]
  end
end