class BillsController < ApplicationController
  
  
  
  
  def index
    
    @bills_grid = initialize_grid(Bill.has_billscore, include: [:billscore])
  end
  def show
   @bill = Bill.find(params[:id])
   @billinfo = @bill.billscore
   @billcount = @billinfo.count
   
  end
end
