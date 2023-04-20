class ProfileController < ApplicationController
  def index
    render json: Profile::GetUserProfileUseCase.new.execute(user: user)
  end

  def feed
    render json: Profile::FeedUseCase.new.execute(user: user, offset: profile_params[:offset])
  end
  private

  def profile_params
    params.permit(:id, :offset).with_defaults(offset: 0)
  end

  def user
    User.find(profile_params[:id])
  rescue StandardError
    nil
  end
end
