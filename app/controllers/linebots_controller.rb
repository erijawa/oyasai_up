class LinebotsController < ApplicationController
  require "line/bot"

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.LINE_CHANNEL_SECRET
      config.channel_token = Rails.application.credentials.LINE_CHANNEL_TOKEN
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::MessageType::Follow #友達登録イベント
        userId = event['source']['userId']
        User.find_or_create_by(uid: userId)
      when Line::Bot::Event::MessageType::Unfollow #友達削除イベント
        userId = event['source']['userId']
        user = User.find_by(uid: userId)
        user.update(uid: nil)
      end
    }

    head :ok
  end
end
