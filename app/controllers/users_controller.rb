class UsersController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
                                        
  def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # ここを修正
      
    else
      render 'new'
    end
  end
  
  def edit
  end  
  
  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to user_path(@user) , notice: 'メッセージを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users_all = @user.following_users
    @users = @user.following_users.page(params[:page])
    #@users = @user.following_users(:followed)
    #@users = @user.following_users(page: params[:page])
    render 'follow_show'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users_all = @user.follower_users
    @users = @user.follower_users.page(params[:page])
    #@users = @user.followers(followed_id)
    #@users = @user.follow(page: params[:page])
    #@users = @user.follower_users.paginate(page: params[:page])
    #@users = @user.follower_users(page: params[:page])
    render 'follow_show'
  end
  
    def index
    @users = @user.follower_users.page(params[:page]).page(2)
    end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :profile, :area)
  end
  
  def set_message
    @user = User.find(params[:id])
  end
  
  def correct_user
    redirect_to root_path if @user != current_user
  end
end
