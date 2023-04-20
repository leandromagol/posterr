class Profile::GetUserProfileUseCase
  def execute(user:)
    raise InvalidUserError unless user.instance_of? User

    { json: { username: user.name, user_posts_count: user.posts.length, date_joined: user.date_joined } }
  end
end
