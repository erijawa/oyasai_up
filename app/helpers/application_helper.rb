module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-info-500"
    when :alert  then "bg-error-500"
    when :error  then "bg-warning-500"
    else "bg-gray-500"
    end
  end
end
