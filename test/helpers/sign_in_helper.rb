module SignInHelper
  def sign_in(user)
    visit user_session_url
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_on "Log in"
    sleep 0.5
  end
end

class ApplicationSystemTestCase
  include SignInHelper
end