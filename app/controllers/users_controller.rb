class UsersController < ApplicationController
  before_action :set_user

  def show
    vegetable_logs = VegetableLog.where(user_id: @user.id)
    @vegetable_logs = vegetable_logs.to_json(only: [ :date, :total ])
    vegetable_log = VegetableLog.find_by(user_id: @user.id, date: Time.zone.today)
    @vegetable_log = vegetable_log ? vegetable_log : VegetableLog.new
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t("defaults.flash_message.created", item: User.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: User.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :avatar_cache)
  end
end
