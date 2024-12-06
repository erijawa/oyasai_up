class VegetableLogsController < ApplicationController
  def create
    @vegetable_log = current_user.vegetable_logs.build(vegetable_log_params)
    if @vegetable_log.save && @vegetable_log.calculate_total
      current_user.update(level: current_user.level + 1) if current_user.vegetable_logs.count % 5 == 0 || current_user.vegetable_logs.count == 1
      redirect_to user_path(current_user), notice: t("defaults.flash_message.vegetable_log.recorded", item: VegetableLog.model_name.human)
    else
      redirect_to user_path(current_user), notice: t("defaults.flash_message.vegetable_log.not_recorded", item: VegetableLog.model_name.human), status: :unprocessable_entity
    end
  end

  def update
    @vegetable_log = current_user.vegetable_logs.find(params[:id])
    if @vegetable_log.update(vegetable_log_params) && @vegetable_log.calculate_total
      redirect_to user_path(current_user), notice: t("defaults.flash_message.vegetable_log.recorded", item: VegetableLog.model_name.human)
    else
      redirect_to user_path(current_user), notice: t("defaults.flash_message.vegetable_log.not_recorded", item: VegetableLog.model_name.human), status: :unprocessable_entity
    end
  end

  private

  def vegetable_log_params
    params.require(:vegetable_log).permit(:breakfast, :lunch, :dinner).merge(date: Time.zone.today)
  end
end
