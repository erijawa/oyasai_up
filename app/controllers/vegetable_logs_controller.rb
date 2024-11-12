class VegetableLogsController < ApplicationController
  def create
    @vegetable_log = current_user.vegetable_logs.build(vegetable_log_params)
    if @vegetable_log.save && @vegetable_log.calculate_total
      redirect_to user_path(current_user), success: "記録しました"
    else
      redirect_to user_path(current_user), success: "記録できませんでした", status: :unprocessable_entity
    end
  end

  def update
    @vegetable_log = current_user.vegetable_logs.find(params[:id])
    if @vegetable_log.update(vegetable_log_params) && @vegetable_log.calculate_total
      redirect_to user_path(current_user), success: "記録しました"
    else
      flash.now[:danger] = "記録できませんでした"
    end
  end

  def vegetable_log_params
    params.require(:vegetable_log).permit(:breakfast, :lunch, :dinner).merge(date: Time.zone.today)
  end
end