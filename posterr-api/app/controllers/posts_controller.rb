class PostsController < ApplicationController
  def store_post
    render json: Posts::PostUseCase.new.execute(user: user, content: post_params[:content]), status: :created
  end

  def store_quote_post
    render json: Posts::QuotePostUseCase.new.execute(user: user, post: post, content: post_params[:content]),
           status: :created
  end

  def store_repost
    render json: Posts::RepostUseCase.new.execute(user: user, post: post), status: :created
  end

  private

  def post_params
    params.permit(:user_id, :content, :post_id)
  end

  def user
    User.find(post_params[:user_id])
  rescue StandardError
    nil
  end

  def post
    Post.find(post_params[:post_id])
  rescue StandardError
    nil
  end
end
