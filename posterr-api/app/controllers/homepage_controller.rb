class HomepageController < ApplicationController
  def index
    date_range = {
      start: search_params[:start_date],
      end: search_params[:end_date]
    }

    render json: Homepage::HomePageUseCase.new.execute(offset: search_params[:offset].to_i,
                                                       limit: search_params[:limit].to_i,
                                                       all_posts: search_params[:all_posts], date_range: date_range,
                                                       user: user), status: :ok
  end

  private

  def search_params
    params.permit(:offset, :limit, :user_id, :all_posts, :start_date, :end_date).with_defaults(all_posts: true,
                                                                                               user_id: false,
                                                                                               offset: 0,
                                                                                               limit: 10).to_h
  end

  def user
    User.find(search_params[:user_id])
  rescue StandardError
    nil
  end

end
