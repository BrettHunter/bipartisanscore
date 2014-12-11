require 'congress/connection'
require 'congress/request'
Congress.key = '300b871e9523419988f04c02e5b80e68'

class Legislator < ActiveRecord::Base
  validates :bioguide_id, uniqueness: true
  has_one :legislatorscore

  def self.get_chamberparty(leg_id)
    record = Legislatorscore.find_by(legislator_id: leg_id)
    chamberparty = record.chamberparty
  end  
  
  def self.chamberparty_count(chamberparty)  
    count = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").count
  end

  def self.chamberparty_rank(chamberparty,mocscore)
    array = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('mocscore')
    array.sort!.reverse!
    rank = array.index(mocscore) + 1 
  end
  
  def self.chamberparty_descriptor(chamberparty)
    if chamberparty == "dem_house"
      descriptor = "House Democrats"
    elsif chamberparty == "dem_senate"
      descriptor = "Senate Democrats"
    elsif chamberparty == "rep_house"
      descriptor = "House Republicans"
    elsif chamberparty == "rep_senate"
      descriptor = "Senate Republicans"
    end
    return descriptor
  end
  
  def self.rank_tie_count(chamberparty,bipartisanscore)
    count = Legislatorscore.where("chamberparty = ? AND bipartisanscore = ?", "#{chamberparty}", "#{bipartisanscore}").count - 1
  end       
  
  def self.get_count(legs)
    count = legs['count']
    return count
  end   

  def self.get_legislators(i)   
    legs = Congress.legislators(page: i , per_page: "1", title: ["Rep", "Sen"], in_office: ["t", "f"], fields: ["title","first_name","last_name","party","state", 
      "bioguide_id", "chamber", "in_office", "gender",  "website",  "term_start", "term_end" ])  
  end

  def self.photo_url(bio_id)
    if bio_id == "w000818"
      return ActionController::Base.helpers.asset_url("bio.svg");
    else
      url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
    end
  end

end