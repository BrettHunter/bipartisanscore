class StaticPagesController < ApplicationController
  def index
    @top_senators = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_senate", "rep_senate").top.limit(4)
    @top_representatives = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_house", "rep_house").top.limit(4)
    @bottom_senators = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_senate", "rep_senate").bottom.limit(4)
    @bottom_representatives = Legislatorscore.includes(:legislator).where("chamberparty = ? OR chamberparty = ?", "dem_house", "rep_house").bottom.limit(4)
    
  end
end
