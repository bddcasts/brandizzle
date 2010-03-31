module UsersHelper
  def present_user(user)
    UserPresenter.new(:user => user)
  end
end