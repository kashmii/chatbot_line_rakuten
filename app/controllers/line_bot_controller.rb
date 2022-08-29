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
          waka_ids = (1..30).to_a
          q_id = waka_ids.sample
          # ここでの削除指定方法は、配列の添字なので-1する必要あり
          waka_ids.delete_at(q_id - 1)
          choice_ids = waka_ids.sample(3)
          choice_ids.push(q_id)
          choice_ids.shuffle!
          waka = Waka.find(q_id)
          # q_id ... 問題に使う和歌のid
          # choice_ids ... 正解の和歌と誤りの和歌3つの計4つの和歌id

          # message1 = {
          #   type: 'text',
          #   text: waka.first_half
          # }
          message2 = flex(choice_ids, q_id, waka)

          # メッセージの返信。応答トークンが使われている
          client.reply_message(event['replyToken'], [message2])
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

    def flex(choice_ids,q_id, waka)
      {
        type: 'flex',
        altText: '百人一首の1~30首を出題しています！',
        contents: make_choices(choice_ids, q_id, waka)
      }
    end

    def make_choices(choice_ids, q_id, waka)
      @wakas = Waka.all
      c0 = choice_ids[0]
      c1 = choice_ids[1]
      c2 = choice_ids[2]
      c3 = choice_ids[3]
      {
        "type": "bubble",
        "size": "mega",
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "'#{waka.first_half}'",
              "weight": "regular",
              "size": "md",
              "align": "center"
            },
            {
              "type": "text",
              "text": "下の句はどれでしょう？",
              "weight": "regular",
              "size": "md",
              "align": "center",
              "offsetTop": "md"
            }
          ],
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "message",
                "label": @wakas[c0 - 1].second_half,
                "text": c0 == q_id ? 
                  "正解！\n作者は #{@wakas[c0 - 1].author}" :
                  "ハズレ！それは #{@wakas[c0 -1].author} の\n#{@wakas[c0 -1].first_half}\n#{@wakas[c0 -1].second_half} という歌です"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "message",
                "label": @wakas[c1 - 1].second_half,
                "text": c1 == q_id ?
                  "正解！\n作者は #{@wakas[c1 - 1].author}" :
                  "ハズレ！それは #{@wakas[c1 -1].author} の\n#{@wakas[c1 -1].first_half}\n#{@wakas[c1 -1].second_half} という歌です"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "message",
                "label": @wakas[c2 - 1].second_half,
                "text": c2 == q_id ?
                  "正解！\n作者は #{@wakas[c2 - 1].author}" :
                  "ハズレ！それは #{@wakas[c2 -1].author} の\n#{@wakas[c2 -1].first_half}\n#{@wakas[c2 -1].second_half} という歌です"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "message",
                "label": @wakas[c3 - 1].second_half,
                "text": c3 == q_id ?
                  "正解！\n作者は #{@wakas[c3 - 1].author}" :
                  "ハズレ！それは #{@wakas[c3 -1].author} の\n#{@wakas[c3 -1].first_half}\n#{@wakas[c3 -1].second_half} という歌です"
              }
            }
          ],
          "flex": 0
        }
      }
    end
end