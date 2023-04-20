class Posts::RepostUseCase
  def execute(user:, post:)
    raise InvalidUserError unless user.instance_of? User
    raise DailyPostsLimitError if user.posts_today >= 5
    raise StandardError, 'post not found' unless post.instance_of? Post
    if post.repost || post.user_id == user.id
      raise StandardError, "you can't repost reposts"
    end

    repost = user.posts.create post_id: post.id
    return { json: { post: repost } } if repost.valid?

    { json: { errors: repost.errors }, status: :bad_request }
  end
end

