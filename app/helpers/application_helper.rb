module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-[#8DBA30]"
    when :alert  then "bg-[#f84c08]"
    when :error  then "bg-[#f6b827]"
    else "bg-gray-500"
    end
  end

  def show_meta_tags
    assign_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end

  def assign_meta_tags(options = {})
    defaults = t("meta-tags.defaults")
    options.reverse_merge!(defaults)

    set_meta_tags(build_meta_tags(options))
  end

  private

  def build_meta_tags(options)
    {
      site: options[:site],
      title: options[:title],
      reverse: true,
      charset: "utf-8",
      description: options[:description],
      keywords: options[:keywords],
      canonical: request.original_url,
      separator: "|",
      icon: icon_tags,
      og: build_og_tags(options),
      twitter: build_twitter_tags(options)
    }
  end

  def icon_tags
    [
      { href: image_url("favicon.ico") },
      { href: image_url("logo.png"), rel: "apple-touch-icon", sizes: "180x180", type: "image/png" }
    ]
  end

  def build_og_tags(options)
    image = options[:image].presence || image_url("default_ogp.png")
    {
      site_name: options[:site],
      title: options[:title].presence || t("meta_tags.defaults.title"),
      description: options[:description],
      type: "website",
      url: request.original_url,
      image:,
      local: "ja-JP"
    }
  end

  def build_twitter_tags(options)
    image = options[:image].presence || image_url("default_ogp.png")
    {
      card: "summary_large_image",
      site: options[:site],
      image:
    }
  end
end
