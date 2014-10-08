class LegislatorsController < ApplicationController
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
    @bills = Legislatorscore.get_pointed_votes(params[:id])
    @point_array = @legislator.legislatorscore.each_vote_points
    @bill_array = @bills.keys
    @top_grid = initialize_grid(Bill.where(bill_id: @bill_array))
    @chamberparty = @legislator.legislatorscore.chamberparty
    @chamberparty_count = Legislator.chamberparty_count(@chamberparty)
    @chamberparty_rank = Legislator.chamberparty_rank(@chamberparty,@legislator.legislatorscore.mocscore)
    @chamberparty_descriptor = Legislator.chamberparty_descriptor(@chamberparty)
    
    
  end
end
