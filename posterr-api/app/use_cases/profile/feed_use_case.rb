class Profile::FeedUseCase
  def execute(user:, limit: 5, offset: 0)
    raise InvalidUserError unless user.instance_of? User

    user.posts.order(created_at: :desc).offset(offset * limit).limit(limit)
  end
end
