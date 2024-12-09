namespace :push_line do
  desc "LINEBOT:おやさいLogのリマインダ通知"
  task push_line_message_task: :environment do
      client = Line::Bot::Client.new { |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
          config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }

      users = User.where.not(uid: nil).need_alert
      users.each do |user|
        message = {
            type: 'text',
            text: "今日はお野菜食べましたか？おやさいLogに記録しましょう！https://www.oyasaiup.com/users/#{user.id}"
        }
        client.push_message(user.uid, message)
      end
  end
end