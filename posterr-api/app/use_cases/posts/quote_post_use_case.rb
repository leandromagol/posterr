class Posts::QuotePostUseCase
  def execute(user:, post:, content:)
    raise InvalidUserError unless user.instance_of? User
    raise DailyPostsLimitError if user.posts_today >= 5
    raise StandardError, 'post not found' unless post.instance_of? Post

    if post.quote_post || post.user_id == user.id
      raise StandardError, "you can't quote this posts"
    end

    quote_post = user.posts.create post_id: post.id, content: content
    return { json: { post: quote_post } } if quote_post.valid?

    { json: { errors: quote_post.errors }, status: :bad_request }
  end
end
