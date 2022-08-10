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
          foods = ['すし食いたい', 'ハンバーグ食べたい', '焼肉食べたい']
          # message = {
            # text: foods.sample,
          # }
          message = search_and_create_message(event.message['text'])
          # メッセージの返信。応答トークンが使われている
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    # 返信に成功した場合のステータスコードを返す
    head :ok
  end

  private

    # これでcallbackアクションからclientメソッドを呼び出すことで、LINE Messaging API SDKの機能を使うことができる
    # (railsからチャネルへのアクセス)
    def client
      # Line::Bot::Clientクラスのインスタンス化,引数をブロック({})で与える必要があります
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    end

    def search_and_create_message(keyword)
      # このhttp_clientでgetメソッドを使うと、指定したURLに対してGETリクエストを行ない、そのレスポンスを取得できます
      http_client = HTTPClient.new
      # リクエストURLとパラメーターの定義
      url = 'https://app.rakuten.co.jp/services/api/Travel/KeywordHotelSearch/20170426'
      query = {
        'keyword' => keyword,
        'applicationId' => ENV['RAKUTEN_APPID'],
        'hits' => 5,
        'responseType' => 'small',
        'datumType' => 1,
        'formatVersion' => 2
      }
      # 楽天APIを叩いた結果をresponseに入れる
      response = http_client.get(url, query)
      response = JSON.parse(response.body)

      # 指定したキー名が存在した場合にtrueを返す
      if response.key?('error')
        # 検索結果0のメッセージ出す
        text = "この検索条件に該当する宿泊施設が見つかりませんでした。\n条件を変えて再検索してください。"
        message = {
          type: 'text',
          text: text
        }
      else
        # 4章：ホテルの各情報をtextに代入
        # text = ''
        # response['hotels'].each do |hotel|
        #   text <<
        #   hotel[0]['hotelBasicInfo']['hotelName'] + "\n" +
        #   hotel[0]['hotelBasicInfo']['hotelInformationUrl'] + "\n" +
        #   "\n"
        # end

        # 5章：エラーがない場合はFlex Messageを返す
        {
          type: 'flex',
          altText: '宿泊検索の結果です。',
          contents: set_carousel(response['hotels'])
        }
      end      
    end
    # 以上で宿泊検索の結果からメッセージを作成するところまでの実装が完了

    def set_carousel(hotels)
      bubbles = []
      hotels.each do |hotel|
        bubbles.push set_bubble(hotel[0]['hotelBasicInfo'])
      end
      {
        type: 'carousel',
        contents: bubbles
      }
    end

    def set_bubble(hotel)
      {
        type: 'bubble',
        hero: set_hero(hotel),
        body: set_body(hotel),
        footer: set_footer(hotel)
      }
    end

    def set_hero(hotel)
      {
        type: 'image',
        url: hotel['hotelImageUrl'],
        size: 'full',
        aspectRatio: '20:13',
        aspectMode: 'cover',
        action: {
          type: 'uri',
          uri: hotel['hotelInformationUrl']
        }
      }
    end

    def set_body(hotel)
      {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: hotel['hotelName'],
            wrap: true,
            weight: 'bold',
            size: 'md'
          },
          {
            type: 'box',
            layout: 'vertical',
            margin: 'lg',
            spacing: 'sm',
            contents: [
              {
                type: 'box',
                layout: 'baseline',
                spacing: 'sm',
                contents: [
                  {
                    type: 'text',
                    text: '住所',
                    color: '#aaaaaa',
                    size: 'sm',
                    flex: 1
                  },
                  {
                    type: 'text',
                    text: hotel['address1'] + hotel['address2'],
                    wrap: true,
                    color: '#666666',
                    size: 'sm',
                    flex: 5
                  }
                ]
              },
              {
                type: 'box',
                layout: 'baseline',
                spacing: 'sm',
                contents: [
                  {
                    type: 'text',
                    text: '料金',
                    color: '#aaaaaa',
                    size: 'sm',
                    flex: 1
                  },
                  {
                    type: 'text',
                    # rail7からはto_sは非推奨らしい：Please use Integer#to_fs(:delimited) instead.
                    text: '￥' + hotel['hotelMinCharge'].to_fs(:delimited) + '〜',
                    wrap: true,
                    color: '#666666',
                    size: 'sm',
                    flex: 5
                  }
                ]
              }
            ]
          }
        ]
      }
    end

    def set_footer(hotel)
      {
        type: 'box',
        layout: 'vertical',
        spacing: 'sm',
        contents: [
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: '電話する',
              uri: 'tel:' + hotel['telephoneNo']
            }
          },
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: '地図を見る',
              uri: 'https://www.google.com/maps?q=' + hotel['latitude'].to_s + ',' + hotel['longitude'].to_s
            }
          },
          {
            type: 'spacer',
            size: 'sm'
          }
        ],
        flex: 0
      }
    end
end
