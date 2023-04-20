class Posts::PostUseCase
  def execute(user:, content:)
    raise InvalidUserError unless user.instance_of? User
    raise DailyPostsLimitError if user.posts_today >= 5

    post = user.posts.create(content: content)
    return post if post.valid?

    raise ActiveRecord::RecordInvalid.new(post)
  end
end
