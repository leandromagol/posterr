class InvalidUserError < StandardError
  def message
    'User is invalid'
  end
end
