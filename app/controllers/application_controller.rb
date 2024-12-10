class ApplicationController < ActionController::Base
  class CsrfProtectionError < StandardError; end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def ensure_correct_user
    @user = User.find(params[:id])
    if !current_user || @user.id != current_user.id
      redirect_back fallback_location: root_path, notice: t("defaults.flash_message.not_authenticated")
    end
  end

  def check_csrf
    # Originが許可されていない場合はエラー
    allowed_origins = [ "https://oyasaiup.com", "https://www.oyasaiup.com" ]
    origin = request.headers["Origin"]

    if origin.blank? || allowed_origins.exclude?(origin)
      raise CsrfProtectionError
    end

    # Sec-Fetch-Siteが存在していて許可されていない場合はエラー
    allowed_values = [ "same-origin", "same-site" ]
    sec_fetch_site = request.headers["Sec-Fetch-Site"]

    if sec_fetch_site.present? && allowed_values.exclude?(sec_fetch_site.downcase)
      raise CsrfProtectionError
    end
  end
end
