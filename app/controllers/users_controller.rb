class UsersController < ApplicationController
	before_action :authenticate_user!

	def show
	 if params[:id]
    @user = User.find(params[:id])
   else
     @user = current_user
   end
  end

  def posts
    @user = User.find(params[:user_id])
    @posts = Post.where(author: @user)
                 .order(created_at: :desc)
                 .includes(:likes, :author, comments: :comments)
  end

  def likes
    @user = User.find(params[:user_id])
    likes_post_ids = Like.where(user_id: @user.id, likable_type: "Post")
                         .pluck(:likable_id)
    @posts = Post.where('id IN (?)', likes_post_ids)
                 .includes(:like, comments: :comments)
                 .order(created_at: :desc)
  end

  def friends
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @friends = @user.friends
                    .order(:name)
  end

  def friend_request
    @invitations = current_user.friend_invitations
                               .order('users.name')
  end

  def find_friends
  end

  def edit
    @user = current_user
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to current_user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

	private

  def user_params
    params.require(:user).permit(
      :location,
      :birthday,
      :occupation,
      :education,
      :education,
      :website
      )
  end
end
