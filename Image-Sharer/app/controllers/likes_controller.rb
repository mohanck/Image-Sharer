class LikesController < ApplicationController
  def new
  end

  def create
    like = Like.new(like_require_params)
    if like.save
      redirect_to root_url, flash: { warning: 'Liked Successful' }
    else
      redirect_to root_url, flash: { warning: 'Image already liked' }
    end
  end

  def destroy
    like = Like.exist?(params[:user_id], params[:image_id])
    like.destroy unless like.blank?
    redirect_to root_url, flash: { success: 'Image Unliked' } unless like.blank?
  end

  private

  def like_require_params
    params.require(:user_id)
    params.require(:image_id)
    params.permit(:user_id, :image_id)
  end
end
