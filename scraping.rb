# ソース: http://shibuya-o.com/east/schedule/

require 'nokogiri'
require 'anemone'

# db読み込み
# 参考: http://shuzo-kino.hateblo.jp/entry/20120913/1347551619
# db = SQLite3::Database.new('./db/development.sqlite3')

# 引数
gigPlace = "O-EAST"
url = "http://shibuya-o.com/east/schedule"

# dbクリーンアップ
Gig.destroy_all(place: "#{gigPlace}")

# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl(url, depth_limit: 0) do |anemone|
  anemone.on_every_page do |page|

    gigYear = page.doc.xpath("//*[@class='year']/text()").to_s
    gigMonth = page.doc.xpath("//*[@class='month on']/p[1]/span[1]/text()").to_s

    page.doc.xpath("//*[@class='schedule_row clearfix']").each do |node|

      gigDay = node.xpath(".//div[@class='date']/p[1]/text()").to_s
      gigTitle = node.xpath(".//*[@class='title']/text()").to_s.gsub( /\r\n|\r|\n/, "")
      gigArtist = node.xpath(".//div[@class='detail_wrap']//text()").to_s.gsub(/¥s+|[\r\n]/, "").strip

      #sql挿入
      gig = Gig.new ({place: "#{gigPlace}", gig_date: "#{gigYear}-#{gigMonth}-#{gigDay}", title: "#{gigTitle}", artist: "#{gigArtist}"})
      gig.save
    end # node終わり
  end # page終わり
end # Anemone終わり
