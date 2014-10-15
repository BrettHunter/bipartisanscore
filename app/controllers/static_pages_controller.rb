class StaticPagesController < ApplicationController
  include Common
  helper_method :photo_url
  
  
  def index
    @top_senators = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_senate", "rep_senate").in_office.top.limit(4)
    @top_representatives = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_house", "rep_house").in_office.top.limit(4)
    @bottom_senators = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_senate", "rep_senate").in_office.bottom.limit(4)
    @bottom_representatives = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_house", "rep_house").in_office.bottom.limit(4)    
  end
  
  def photo_url(bio_id)
    if bio_id == "w000818"
      return ActionController::Base.helpers.asset_url("bio.svg");
    else
      url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
    end
  end
  
  
  
end
