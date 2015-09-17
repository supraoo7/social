class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    user_ids = current_user.timeline_user_ids

    #debugger

    @posts = Post.includes(:user).where(user_id: user_ids).paginate(page: params[:page], per_page: 5).order("created_at DESC")

    logger.debug "***** current_user.inspect = "
    logger.debug current_user.inspect

    @posts.each do |post|
      logger.debug "***** post id and type *****"
      logger.debug "#{post.id} #{post.type}"
    end
  end

  def show 
    @post = Post.find(params[:id])
    @post.comments = Comment.includes(:user)
    @can_moderate = (current_user == @post.user)
  end
end
