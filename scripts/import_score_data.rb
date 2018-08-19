#
# usage:
#   rails runner scripts/ImportScoreData.rb user_id store_ids tsv-filepath [start_date]
#     user_id      : User ID
#     store_ids    : 'all' or 'store_id,store_id,store_id,...'
#     tsv-filepath : tsv file full path
#     start_date   : start date of 'YYYYMMDD'
#

require 'csv'

class ImportScoreData

  MODELS = ['GOD', 'バジリスク絆', '海物語', '海物語2']

  def self.seat
    Random.rand(1000..9999)
  end

  def self.run(user, stores, start_date, tsv_filename)
    date = start_date
    rows = CSV.read(tsv_filename, col_sep: "\t", headers: false)
    rows.each do |row|
      next if row[0].nil?

      score = user.scores.new
      score.store = stores.sample
      score.model = MODELS.sample
      score.seat = self.seat
      score.investment = (row[0].to_i * (Random.rand(8..12) / 10.0)).to_i
      score.proceeds = (row[1].to_i * (Random.rand(8..12) / 10.0)).to_i
      score.start_at = Time.new(date.year, date.month, date.day, Random.rand(10..15))
      score.end_at = score.start_at + Random.rand(1..5).hours
      score.save!
      puts score.inspect

      date += 1.day
      break if date >= Date.today.to_time
    end
  end
end

user_id = ARGV[0].to_i
if ARGV[1] == 'all'
  store_ids = nil
else
  store_ids = ARGV[1].split(',').map(&:to_i)
end
tsv_filename = ARGV[2]

start_date = Time.strptime(ARGV[3] || '20180101', '%Y%m%d')

user = User.find_by(id: user_id)
if user.blank?
  puts "user_id=#{user_id}のユーザが見つかりません。"
  exit 1
end

stores = Store.all
stores = stores.where(id: store_ids) if store_ids.present?
if stores.blank?
  puts "store_ids=[#{store_ids.join(',')}]の店舗が見つかりません。"
  exit 1
end

unless File.exist?(tsv_filename)
  puts "TSVファイル[#{tsv_filename}]が見つかりません。"
  exit 1
end

ImportScoreData.run(user, stores, start_date, tsv_filename)
