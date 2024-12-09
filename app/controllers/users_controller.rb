class UsersController < ApplicationController
  before_action :ensure_correct_user, only: %i[ edit update ]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
    vegetable_logs = VegetableLog.where(user_id: @user.id)
    @vegetable_logs = vegetable_logs.to_json(only: [ :date, :total ])
    vegetable_log = VegetableLog.find_by(user_id: @user.id, date: Time.zone.today)
    @vegetable_log = vegetable_log ? vegetable_log : VegetableLog.new
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t("defaults.flash_message.edited", item: User.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_edited", item: User.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar, :avatar_cache, :line_alert)
  end
end
