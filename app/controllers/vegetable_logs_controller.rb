class VegetableLogsController < ApplicationController
  def create
    breakfast = vegetable_log_params[:breakfast].to_i
    lunch = vegetable_log_params[:lunch].to_i
    dinner = vegetable_log_params[:dinner].to_i
    @vegetable_log = current_user.vegetable_logs.build(breakfast: breakfast, lunch: lunch, dinner: dinner, date: Time.zone.today)
    p @vegetable_log
    if @vegetable_log.save && @vegetable_log.calculate_total
      redirect_to user_path(current_user), notice: "記録しました"
    else
      redirect_to user_path(current_user), notice: "記録できませんでした", status: :unprocessable_entity
    end
  end

  def update
    @vegetable_log = current_user.vegetable_logs.find(params[:id])
    breakfast = vegetable_log_params[:breakfast].to_i
    lunch = vegetable_log_params[:lunch].to_i
    dinner = vegetable_log_params[:dinner].to_i
    if @vegetable_log.update(breakfast: breakfast, lunch: lunch, dinner: dinner) && @vegetable_log.calculate_total
      redirect_to user_path(current_user), notice: "記録しました"
    else
      redirect_to user_path(current_user), notice: "記録できませんでした", status: :unprocessable_entity
    end
  end

  private

  def vegetable_log_params
    params.require(:vegetable_log).permit(:breakfast, :lunch, :dinner)
  end
end