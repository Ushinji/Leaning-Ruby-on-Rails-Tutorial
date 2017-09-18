require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{ session:{ email:"", password:""} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                        password: 'password' }}
    assert is_logged_in?
    assert_redirected_to @user  #リダイレクト先が正しいかチェック
    follow_redirect!  #上の行のリダイレクト先へ実際に繊維
    assert_select "a[href=?]", login_path, count:0 #ログイン用リンクが無いことを確認
    assert_select "a[href=?]", logout_path  #ユーザページにログアウト用リンクがあること確認
    assert_select "a[href=?]", user_path(@user) #ユーザのプロフィール様リンクが表示されている確認

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), cout:0
  end
end
