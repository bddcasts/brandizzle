module UsersHelper
  def present_user(user)
    UserPresenter.new(:user => user)
  end
  
  def gravatar_url(email)
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&size=32"
  end
end