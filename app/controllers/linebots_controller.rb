class LinebotsController < ApplicationController
  require "line/bot"

  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.LINE_CHANNEL_SECRET
      config.channel_token = Rails.application.credentials.LINE_CHANNEL_TOKEN
    }
  end

  def callback
    body = request.body.read

    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      user_id = event["source"]["userId"]
      user = User.find_by(uid: user_id)
      if event.message["text"].include?("リマインダ登録")
        text_content = "リマインダを設定しました。毎日20時におやさいLogのリマインダを送信します。"
        user.need_alert!
      elsif event.message["text"].include?("リマインダ解除")
        text_content = "おやさいLogのリマインダを解除しました。リマインダを再開したい時は「リマインダ登録」と送信してください。"
        user.no_alert!
      else
        text_content = "このトークルームではおやさいLogのリマインダ設定の変更ができます。リマインダが必要な場合は「リマインダ登録」、解除したいときは「リマインダ解除」と送信してください。"
      end
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: text_content
          }
          client.reply_message(event["replyToken"], message)
        when Line::Bot::Event::MessageType::Follow # 友達登録イベント
          User.find_or_create_by(uid: user_id)
        when Line::Bot::Event::MessageType::Unfollow # 友達削除イベント
          user.update(uid: nil)
        end
      end
    }

    head :ok
  end
end
