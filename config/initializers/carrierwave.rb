require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_directory  = Rails.application.credentials.S3_BUCKET_NAME
    config.fog_public = false
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Rails.application.credentials.S3_ACCESS_KEY_ID,
      aws_secret_access_key: Rails.application.credentials.S3_SECRET_ACCESS_KEY
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
