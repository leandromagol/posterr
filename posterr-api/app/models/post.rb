class Post < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true
  validates :content, length: { minimum: 1, maximum: 777 }, allow_blank: true

  def repost
    self.post_id && self.content? == false
  end

  def quote_post
    self.content && self.post_id
  end
end
