# coding: utf-8

[
  {id: 1, author:'天智天皇', first_half:'秋の田のかりほの庵の苫を荒み', second_half:'わがころも手は露に濡れつつ'},
  {id: 2, author:'持統天皇', first_half:'春すぎて夏来にけらし白たへの', second_half:'ころもほすてふあまの香具山'},
  {id: 3, author:'柿本人麻呂', first_half:'あしひきの山鳥の尾のしだり尾の', second_half:'ながながし夜をひとりかも寝む'},
  {id: 4, author:'山部赤人', first_half:'田子の浦にうちいでて見れば白たへの', second_half:'富士の高嶺に雪は降りつつ'},
  {id: 5, author:'猿丸太夫', first_half:'奥山にもみぢ踏み分け鳴く鹿の', second_half:'声聞く時ぞ秋は悲しき'},

  {id: 6, author:'中納言(大伴)家持', first_half:'かささぎの渡せる橋に置く霜の', second_half:'白きを見れば夜ぞふけにける'},
  {id: 7, author:'安倍仲麻呂', first_half:'あまの原ふりさけ見ればかすがなる', second_half:'み笠の山にいでし月かも'},
  {id: 8, author:'喜撰法師', first_half:'わが庵は都のたつみしかぞ住む', second_half:'世を宇治山と人は言ふなり'},
  {id: 9, author:'小野小町', first_half:'花の色はうつりにけりないたづらに', second_half:'わが身世にふるながめせしまに'},
  {id: 10, author:'蝉丸', first_half:'これやこの行くも帰るも別れては', second_half:'知るも知らぬも逢坂の関'},
  
  {id: 11, author:'参議(小野)篁', first_half:'わたの原八十島かけて漕ぎいでぬと', second_half:'人には告げよあまの釣舟'},
  {id: 12, author:'僧正遍昭', first_half:'あまつ風雲のかよひ路吹きとぢよ', second_half:'をとめの姿しばしとどめむ'},
  {id: 13, author:'陽成院', first_half:'つくばねの峰より落つるみなの川', second_half:'恋ぞ積りて淵となりぬる'},
  {id: 14, author:'河原左大臣(源融)', first_half:'みちのくの忍ぶもぢずり誰ゆゑに', second_half:'乱れそめにしわれならなくに'},
  {id: 15, author:'光孝天皇', first_half:'君がため春の野にいでて若菜摘む', second_half:'わがころも手に雪は降りつつ'},
  
  {id: 16, author:'中納言(在原)行平', first_half:'立ち別れいなばの山の峰に生ふる', second_half:'まつとし聞かばいざ帰り来む'},
  {id: 17, author:'在原業平朝臣', first_half:'ちはやふる神代も聞かず竜田川', second_half:'からくれなゐに水くくるとは'},
  {id: 18, author:'藤原敏行朝臣', first_half:'すみの江の岸による波よるさへや', second_half:'夢のかよひ路人目よくらむ'},
  {id: 19, author:'伊勢', first_half:'なにはがた短きあしのふしのまも', second_half:'あはでこの世をすごしてよとや'},
  {id: 20, author:'元良親王', first_half:'わびぬれば今はた同じなにはなる', second_half:'みをつくしてもあはむとぞ思ふ'},

  {id: 21, author:'素性法師', first_half:'今来むと言ひしばかりに', second_half:'長月の有明の月を待ちいでつるかな'},
  {id: 22, author:'文屋康秀', first_half:'吹くからに秋の草木のしをるれば', second_half:'むべ山風を嵐と言ふらむ'},
  {id: 23, author:'大江千里', first_half:'	月見ればちぢにものこそ悲しけれ', second_half:'わが身ひとつの秋にはあらねど'},
  {id: 24, author:'菅家(菅原道真)', first_half:'このたびはぬさも取りあへずたむけ山', second_half:'もみぢのにしき神のまにまに'},
  {id: 25, author:'三条右大臣(藤原定方)', first_half:'名にし負はば逢坂山のさねかづら', second_half:'人に知られで来るよしもがな'},

  {id: 26, author:'貞信公(藤原忠平)', first_half:'小倉山峰のもみぢ葉心あらば', second_half:'今ひとたびのみゆき待たなむ'},
  {id: 27, author:'中納言(藤原)兼輔', first_half:'みかの原わきて流るる泉川', second_half:'いつ見きとてか恋しかるらむ'},
  {id: 28, author:'源宗干朝臣', first_half:'山里は冬ぞ寂しさまさりける', second_half:'人目も草もかれぬと思へば'},
  {id: 29, author:'凡河内躬恒', first_half:'心あてに折らばや折らむ初霜の', second_half:'置きまどはせる白菊の花'},
  {id: 30, author:'壬生忠岑', first_half:'有明のつれなく見えし別れより', second_half:'暁ばかりうきものはなし'}
].each do |attributes|
  Waka.find_or_initialize_by(id: attributes[:id]).update!(attributes)
end