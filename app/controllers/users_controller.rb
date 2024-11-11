class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    vegetable_logs = VegetableLog.where(user_id: @user.id)
    @vegetable_logs = vegetable_logs.to_json(only: [:date, :total])
    vegetable_log = VegetableLog.find_by(user_id: @user.id, date: Time.zone.today)
    @vegetable_log = vegetable_log ? vegetable_log : VegetableLog.new
  end
end
