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
    @senate_democrats = Legislator.where("in_office = ? AND chamber = ? AND party = ?", "t", "senate", "D").count
    @senate_republicans = Legislator.where("in_office = ? AND chamber = ? AND party = ?", "t", "senate", "R").count
    @house_democrats = Legislator.where("in_office = ? AND chamber = ? AND party = ?", "t", "house", "D").count
    @house_republicans = Legislator.where("in_office = ? AND chamber = ? AND party = ?", "t", "house", "R").count
    @senate_democrat_bp_votes = Legislatorscore.average_bipartisan_votes("dem_senate")
    @senate_republican_bp_votes = Legislatorscore.average_bipartisan_votes("rep_senate")
    @house_democrat_bp_votes = Legislatorscore.average_bipartisan_votes("dem_house")
    @house_republican_bp_votes = Legislatorscore.average_bipartisan_votes("rep_house")
    @senate_democrat_bp_points = Legislatorscore.average_bipartisan_points("dem_senate")
    @senate_republican_bp_points = Legislatorscore.average_bipartisan_points("rep_senate")
    @house_democrat_bp_points = Legislatorscore.average_bipartisan_points("dem_house")
    @house_republican_bp_points = Legislatorscore.average_bipartisan_points("rep_house")
    @senate_democrat_party_percentage = Legislatorscore.average_party_percentage("dem_senate")
    @senate_republican_party_percentage = Legislatorscore.average_party_percentage("rep_senate")
    @house_democrat_party_percentage = Legislatorscore.average_party_percentage("dem_house")
    @house_republican_party_percentage = Legislatorscore.average_party_percentage("rep_house")
    @senate_democrat_yea_votes = Legislatorscore.average_yea_votes("dem_senate")
    @senate_republican_yea_votes = Legislatorscore.average_yea_votes("rep_senate")
    @house_democrat_yea_votes = Legislatorscore.average_yea_votes("dem_house")
    @house_republican_yea_votes = Legislatorscore.average_yea_votes("rep_house")
    @senate_democrat_nay_votes = Legislatorscore.average_nay_votes("dem_senate")
    @senate_republican_nay_votes = Legislatorscore.average_nay_votes("rep_senate")
    @house_democrat_nay_votes = Legislatorscore.average_nay_votes("dem_house")
    @house_republican_nay_votes = Legislatorscore.average_nay_votes("rep_house")
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
    @fburl = "#{request.original_url}"
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
