class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def ensure_correct_user
    @user = User.find(params[:id])
    if !current_user || @user.id != current_user.id
      redirect_back fallback_location: root_path, notice: t("defaults.flash_message.not_authenticated")
    end
  end
end
