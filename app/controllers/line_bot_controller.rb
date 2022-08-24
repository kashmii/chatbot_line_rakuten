class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    # []の中が署名の変数
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    # 署名の確認ができなかった場合、bad_requestを返す
    unless client.validate_signature(body, signature)
      return head :bad_request
    end
    # メッセージボディを配列に変換
    events = client.parse_events_from(body)
    # 送信されたメッセージがテキストメッセージかどうかの検証をおこないます
    events.each do |event|
      # eventがLine::Bot::Event::Messageクラスかどうか、
      # つまりユーザーがメッセージを送信したことを示すイベントかどうかを確認
      case event
      when Line::Bot::Event::Message
        # event.typeがMessageType::Textだったら
        case event.type
        when Line::Bot::Event::MessageType::Text
          # 返信メッセージの作成
          foods = [
            "1 秋の田のかりほの庵の苫を荒み\nわがころも手は露に濡れつつ\n天智天皇",
            "2 春すぎて夏来にけらし白たへの\nころもほすてふあまの香具山\n持統天皇",
            "3 あしひきの山鳥の尾のしだり尾の\nながながし夜をひとりかも寝む\n柿本人麻呂",
            "4 田子の浦にうちいでて見れば白たへの\n富士の高嶺に雪は降りつつ\n山部赤人",
            "5 奥山にもみぢ踏み分け鳴く鹿の\n声聞く時ぞ秋は悲しき\n猿丸太夫"
          ]
          message = {
            type: 'text',
            text: foods.sample,
          }
          # メッセージの返信。応答トークンが使われている
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    # 返信に成功した場合のステータスコードを返す
    head :ok
  end

  private

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      }
    end
end