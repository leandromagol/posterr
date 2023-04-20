class ApplicationController < ActionController::API
  rescue_from InvalidUserError, with: :error_message
  rescue_from StandardError,DailyPostsLimitError, with: :error_message
  rescue_from ActiveRecord::RecordInvalid, with: :database_validation_error

  def database_validation_error(e)
    render json: e.record.errors, status: :unprocessable_entity
  end

  def error_message(e)
    render json: { message: e.message }, status: :bad_request
  end
end
