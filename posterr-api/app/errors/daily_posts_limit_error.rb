class DailyPostsLimitError < StandardError
  def message
    'Daily posts limit reached'
  end
end
