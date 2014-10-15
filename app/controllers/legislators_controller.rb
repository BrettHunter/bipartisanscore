class LegislatorsController < ApplicationController
  helper_method :photo_url
  helper_method :gender_descriptor
  
  def index
    @legislators_grid = initialize_grid(Legislator, 
      :conditions => ['in_office = ?', 't'],
      include: [:legislatorscore],
      order: 'legislatorscores.bipartisanscore',
      order_direction: 'desc',
      )
  end
  def show
    @legislator = Legislator.find(params[:id])
    @legislator_chamber = @legislator.chamber
    @bills = Legislatorscore.get_pointed_votes("#{@legislator.bioguide_id}")
    @point_array = @legislator.legislatorscore.each_vote_points
    @bill_array = @bills.keys
    @top_grid = initialize_grid(Bill.where(bill_id: @bill_array))
    @chamberparty = @legislator.legislatorscore.chamberparty
    @chamberparty_count = Legislator.chamberparty_count(@chamberparty)
    @chamberparty_rank = Legislator.chamberparty_rank(@chamberparty,@legislator.legislatorscore.mocscore)
    @chamberparty_descriptor = Legislator.chamberparty_descriptor(@chamberparty)    
  end
  
  def photo_url(bio_id)
    if bio_id == "w000818"
      return ActionController::Base.helpers.asset_url("bio.svg");
    else
      url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
    end
  end
  
  def gender_descriptor(bio_id)
    gender = Legislator.find_by(bioguide_id: bio_id).gender
    if gender == "M"
      descriptor = "he"
    else
      descriptor = "she"
    end
  end
  
end
