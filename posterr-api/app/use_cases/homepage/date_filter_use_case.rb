class Homepage::DateFilterUseCase
  def execute(start_date:, end_date:)
    start_date = parse_date(start_date, nil)
    end_date = parse_date(end_date, nil)
    return only_start_date(start_date) if end_date.nil? && !start_date.nil?
    return only_end_date(end_date) if start_date.nil? && !end_date.nil?

    between_dates(start_date, end_date)
  end

  private

  def parse_date(date, default)
    DateTime.parse(date)
  rescue StandardError
    default
  end

  def only_start_date(start_date)
    Post.where('created_at >= ?', start_date)
  end

  def only_end_date(end_date)
    Post.where('created_at <= ?', end_date)
  end

  def between_dates(start_date, end_date)
    Post.where(created_at: start_date..end_date)
  end
end
