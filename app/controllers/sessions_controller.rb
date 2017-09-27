class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user # user_url(user)へ自動変換
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new' #同じコントローラ内のビューファイルを指定
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
