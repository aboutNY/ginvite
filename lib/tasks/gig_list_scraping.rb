# ソース: http://shibuya-o.com/east/schedule/
require 'nokogiri'
require 'anemone'
require 'sqlite3'

opts = {
    depth_limit: 0
}

# 公演場所オブジェクト
gigPlace = "O-EAST"


# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl("http://shibuya-o.com/east/schedule", opts) do |anemone|
  # 指定したページのあらゆる情報(urlやhtmlなど)をゲットします。
  anemone.on_every_page do |page|

    # page.docでnokogiriインスタンスを取得し、xpathで欲しい要素(ノード)を絞り込む
    # page.doc.xpath("//*[@class='title']").each do |node|
    # title =  node.xpath("text()").to_s
    # page.doc.xpath("/html/body/article/div[@class='contents clearfix']/div[@class='main_contents']/section[@class='sec_inner']/div[@id='schedule_wrap']").each do |node|

    gigYear = page.doc.xpath("//*[@class='year']/text()").to_s
    gigMonth = page.doc.xpath("//*[@class='month on']/p[1]/span[1]/text()").to_s

    page.doc.xpath("//*[@class='schedule_row clearfix']").each do |node|

      gigDay = node.xpath(".//div[@class='date']/p[1]/text()").to_s
      gigDayofweek = node.xpath(".//div[@class='date']/p[2]/text()").to_s
      gigTitle = node.xpath(".//*[@class='title']/text()").to_s.gsub( /\r\n|\r|\n/, "")
      gigArtist = node.xpath(".//div[@class='detail_wrap']//text()").to_s.gsub(/¥s+|[\r\n]/, "").strip

      # puts "日程:" + gigPlace + "アーティスト名：" + gigPlace + " 公演場所： " + gigPlace
       puts  "公演場所：" + gigPlace + " 日程： #{gigYear}-#{gigMonth}-" + gigDay + "(#{gigDayofweek})" + " タイトル:" + gigTitle + " アーティスト:#{gigArtist}"
      # puts gigArtist
       puts "\n-----------------------------------------------\n"
    end # node終わり
  end # page終わり
end # Anemone終わり
