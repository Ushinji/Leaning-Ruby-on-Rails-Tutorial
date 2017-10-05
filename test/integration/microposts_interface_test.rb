require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_url
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'

    # 無効なマイクロポストの投稿
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select "div#error_explanation"

    # マイクロポストの投稿
    content = "test micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # マイクロポストの削除
    assert_select 'a', text:'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # 他ユーザーページに、マイクロポスト削除リンクが無いこと
    get user_path(users(:archer))
    assert_select 'a', text:'delete', count: 0
  end

end
