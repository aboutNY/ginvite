# ソース: http://shibuya-o.com/east/schedule/
require 'nokogiri'
require 'anemone'
require 'sqlite3'

# db読み込み
# 参考: http://shuzo-kino.hateblo.jp/entry/20120913/1347551619
db = SQLite3::Database.new('scraping.db')
##ファイルが無い場合、テーブルの作成
sql = <<SQL
create table if not exists gigdata (
place text,
date  text,
title text,
artist text
);
SQL
db.execute(sql)
# puts "New file is created."

# 引数
gigPlace = "O-EAST"
url = "http://shibuya-o.com/east/schedule"

# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl(url, depth_limit: 0) do |anemone|
  # 指定したページのあらゆる情報(urlやhtmlなど)をゲットします。
  anemone.on_every_page do |page|

    gigYear = page.doc.xpath("//*[@class='year']/text()").to_s
    gigMonth = page.doc.xpath("//*[@class='month on']/p[1]/span[1]/text()").to_s

    page.doc.xpath("//*[@class='schedule_row clearfix']").each do |node|

      gigDay = node.xpath(".//div[@class='date']/p[1]/text()").to_s
      # gigDayofweek = node.xpath(".//div[@class='date']/p[2]/text()").to_s
      gigTitle = node.xpath(".//*[@class='title']/text()").to_s.gsub( /\r\n|\r|\n/, "")
      gigArtist = node.xpath(".//div[@class='detail_wrap']//text()").to_s.gsub(/¥s+|[\r\n]/, "").strip

      #sql挿入
      sql = "insert into gigdata values (\"#{gigPlace}\", \"#{gigYear}-#{gigMonth}-#{gigDay}\", \"#{gigTitle}\", \"#{gigArtist}\")"
      db.execute(sql)

      ## puts "日程:" + gigPlace + "アーティスト名：" + gigPlace + " 公演場所： " + gigPlace
      # puts  "公演場所：" + gigPlace + " 日程： #{gigYear}-#{gigMonth}-" + gigDay + "(#{gigDayofweek})" + " タイトル:" + gigTitle + " アーティスト:#{gigArtist}"
      ## puts gigArtist
      # puts "\n-----------------------------------------------\n"
    end # node終わり
  end # page終わり
end # Anemone終わり

#レコードを取得する
db.execute('select * from gigdata') do |row|
  #rowは結果の配列
  puts row.join("\t")
end
db.close
