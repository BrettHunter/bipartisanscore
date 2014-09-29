class BillsController < ApplicationController
  
  
  
  
  def index
    
    @bills_grid = initialize_grid(Bill.has_billscore)
  end
  def show
   @bill = Bill.find(params[:id])
   @billinfo = @bill.billscore
   
  end
end
