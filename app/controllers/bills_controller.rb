class BillsController < ApplicationController
  include Common
  helper_method :bipartisan_descriptor
  helper_method :photo_url
  
  
  
  
  def index    
    @bills_grid = initialize_grid(Bill.has_billscore, include: [:billscore])
  end
  def show
    @bill = Bill.find(params[:id])
    @billinfo = @bill.billscore
    @billcount = @billinfo.count
    @descriptor = bipartisan_descriptor(@bill.billscore[0].global_rank)
    @house_billscore = @bill.billscore.where("chamber = ?", "house").retrieve_vote
    @senate_billscore = @bill.billscore.where("chamber = ?", "senate").retrieve_vote
    @house_question = Vote.where("bill_id = ? AND chamber = ? AND pertinent_vote = ?", "#{@bill.bill_id}", "house", "true").pluck('question')[0]
    @senate_question = Vote.where("bill_id = ? AND chamber = ? AND pertinent_vote = ?", "#{@bill.bill_id}", "senate", "true").pluck('question')[0]
    @sponsor_id = @bill.sponsor_id.downcase
    @sponsor = Legislator.where("bioguide_id = ?", "#{@sponsor_id}")[0]
    @cosponsor_ids = @bill.cosponsor_ids.map(&:downcase)
    @cosponsor = Legislator.where(bioguide_id: @cosponsor_ids) 
    @fburl = "#{request.original_url}"
  end
  
  def bipartisan_descriptor(bp_score)
      if bp_score > 90
        descriptor = "Extremely Bipartisan"
      elsif bp_score > 75
        descriptor = "Very Bipartisan"
      elsif bp_score > 50
        descriptor = "Somewhat Bipartisan"
      elsif bp_score > 25
        descriptor = "Very Partisan"
      else
        descriptor = "Extremely Partisan"
      end
    end
  
  def photo_url(bio_id)
    if bio_id == "w000818"
      return ActionController::Base.helpers.asset_url("bio.svg");
    else
      url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
    end
  end
  
end
