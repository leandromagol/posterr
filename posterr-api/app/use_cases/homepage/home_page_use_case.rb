class Homepage::HomePageUseCase
  def execute(limit: 10, offset: 0, user: nil, all_posts: true, date_range: { start: nil, end: nil })
    post = Homepage::DateFilterUseCase.new.execute(start_date: date_range[:start], end_date: date_range[:end])
    return post.order(created_at: :desc).offset(offset * limit).limit(limit) if all_posts_fix_typo(all_posts)

    raise InvalidUserError unless user.instance_of? User

    post.where(user_id: user.id).order(created_at: :desc).offset(offset * limit).limit(limit)
  end

  private

  def all_posts_fix_typo(all_posts)
    return true if all_posts.instance_of? TrueClass

    ActiveRecord::Type::Boolean.new.cast(all_posts)
  end
end
