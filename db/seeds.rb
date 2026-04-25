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
