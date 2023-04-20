class User < ApplicationRecord
  has_many :posts
  NAME_REGULAR_EXPRESSION = /\A[a-zA-Z0-9]*\z/.freeze
  validates :name, presence: true, uniqueness: true, length: { maximum: 14 },
                   format: { with: NAME_REGULAR_EXPRESSION, message: 'no special characters, only letters and numbers' }
  def date_joined
    self.created_at.strftime("%B %d, %Y")
  end
  def posts_today
    posts.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day).count
  end
end
