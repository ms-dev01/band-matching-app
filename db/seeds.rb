# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 活動ジャンルを定義
activity_genres = [
  "J-ROCK",
  "J-POP",
  "ロック",
  "ポップス",
  "オルタナティブ",
  "インディーズ",
  "メタル",
  "ハードロック",
  "パンク",
  "エモ",
  "スクリーモ",
  "ヒップホップ",
  "R&B",
  "ファンク",
  "ジャズ",
  "ブルース",
  "クラシック",
  "EDM",
  "テクノ",
  "アニソン",
  "ボカロ"
]

activity_genres.each do |activity_genre|
  # 同じ名前のデータがあればそれを使い、なければ新しく作る（重複防止）
  ActivityGenre.find_or_create_by(name: activity_genre)
end

# 活動地域を定義
activity_areas = [
  "北海道",
  "青森県",
  "岩手県",
  "宮城県",
  "秋田県",
  "山形県",
  "福島県",
  "茨城県",
  "栃木県",
  "群馬県",
  "埼玉県",
  "千葉県",
  "東京都",
  "神奈川県",
  "新潟県",
  "富山県",
  "石川県",
  "福井県",
  "山梨県",
  "長野県",
  "岐阜県",
  "静岡県",
  "愛知県",
  "三重県",
  "滋賀県",
  "京都府",
  "大阪府",
  "兵庫県",
  "奈良県",
  "和歌山県",
  "鳥取県",
  "島根県",
  "岡山県",
  "広島県",
  "山口県",
  "徳島県",
  "香川県",
  "愛媛県",
  "高知県",
  "福岡県",
  "佐賀県",
  "長崎県",
  "熊本県",
  "大分県",
  "宮崎県",
  "鹿児島県",
  "沖縄県"
]

activity_areas.each do |activity_area|
  # 同じ名前のデータがあればそれを使い、なければ新しく作る（重複防止）
  ActivityArea.find_or_create_by(name: activity_area)
end

# 性格タグを定義
personalities = [
  "フレンドリー",
  "明るい",
  "話し上手",
  "聞き上手",
  "優しい",
  "穏やか",
  "サポート好き",
  "まとめるのが好き",
  "活動的",
  "真面目",
  "決断力がある",
  "クリエイティブ"
]

personalities.each do |personality|
  # 同じ名前のデータがあればそれを使い、なければ新しく作る（重複防止）
  Personality.find_or_create_by(name: personality)
end

# 好きなバンドタグを定義
favorite_bands = [
  "ONE OK ROCK",
  "RADWIMPS",
  "BUMP OF CHICKEN",
  "Mr.Children",
  "King Gnu",
  "Official髭男dism",
  "Aimer",
  "Perfume",
  "嵐",
  "乃木坂46",
  "欅坂46",
  "BABYMETAL",
  "MAN WITH A MISSION",
  "Alexandros",
  "LiSA",
  "Eve",
  "YOASOBI",
  "THE ORAL CIGARETTES",
  "SCANDAL",
  "あいみょん",
  "サカナクション",
  "King & Prince",
  "Snow Man",
  "sumika",
  "coldrain",
  "Fear, and Loathing in Las Vegas",
  "凛として時雨",
  "B'z",
  "GLAY",
  "LUNA SEA",
  "ZARD",
  "サザンオールスターズ",
  "Radiohead",
  "Muse",
  "Linkin Park",
  "Green Day",
  "Foo Fighters",
  "Coldplay",
  "Nirvana",
  "Paramore",
  "Imagine Dragons",
  "Red Hot Chili Peppers",
  "Queen",
  "The Beatles",
  "Backstreet Boys",
  "One Direction",
  "Maroon 5",
  "Adele",
  "Taylor Swift",
  "Ed Sheeran"
]

favorite_bands.each do |favorite_band|
  # 同じ名前のデータがあればそれを使い、なければ新しく作る（重複防止）
  FavoriteBand.find_or_create_by(name: favorite_band)
end
