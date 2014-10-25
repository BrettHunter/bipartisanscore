require 'congress/connection'
require 'congress/request'
Congress.key = '300b871e9523419988f04c02e5b80e68'

class Bill < ActiveRecord::Base
  extend FriendlyId
  friendly_id :bill_id
  has_many :billscore, foreign_key: "bill_table_id"
  has_many :vote, foreign_key: "bill_table_id"
  serialize  :urls, JSON
  serialize  :cosponsor_ids, JSON
  scope :recent, -> { order("bills.updated_at DESC") }
  scope :has_billscore, -> { 
    joins(:billscore).
    where("result != ?", "nil")
    }

  
  def self.get_last_api_update()
    obj = Congress.bills(order: 'last_action_at').first
    update = obj[1][0].last_action_at  
  end
    
  def self.get_last_db_update()
    obj = Bill.recent.first
    if obj == nil
      return nil
    else
    update = obj.updated_at  
    end
  end

  def self.get_bill_from_api(i)
    record = Congress.bills(page: i , per_page: "1", congress: "113", order: "last_action_at", fields: ["bill_id", "chamber", "congress", 
      "last_action_at","official_title", "popular_title", "short_title", "sponsor_id", "urls",  "summary",
      "summary_short", "cosponsor_ids"])    
  end
    
  def self.create_bill(obj)
    record = obj.results[0]
    Bill.create(bill_id: record.bill_id, chamber: record.chamber, congress: record.congress,
      last_action_at: record.last_action_at, official_title: record.official_title,
      popular_title: record.popular_title, short_title: record.short_title, sponsor_id: record.sponsor_id, urls: record.urls, 
      summary: record.summary, summary_short: record.summary_short, cosponsor_ids: record.cosponsor_ids)  
  end

  def self.update_bill(api_obj,db_obj)
    api_record = api_obj.results[0]
    db_obj.update(bill_id: api_record.bill_id, chamber: api_record.chamber, congress: api_record.congress,
      last_action_at: api_record.last_action_at, official_title: api_record.official_title,
      popular_title: api_record.popular_title, short_title: api_record.short_title, sponsor_id: api_record.sponsor_id, urls: api_record.urls, 
      summary: api_record.summary, summary_short: api_record.summary_short, cosponsor_ids: api_record.cosponsor_ids)
  end  
  
  def self.combined_opposition_factor(bill_id)
    ary = Billscore.where(bill_id: bill_id).pluck('pscore')
    factor = ary.inject(:+)    
  end
 
  def bill_rank(id)
    bill = Bill.find_by(id: id)
    rel = bill.billscore.count
    factor = bill.billscore.first.combined_pscore
    array = Billscore.where("chamber = ?", bill.billscore.first.chamber).pluck('combined_pscore')
    array.sort!
    rank = array.index(factor) + 1 
    count = array.count
  return rank, count
  end
  
  
end