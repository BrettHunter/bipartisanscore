module BillsHelper
  def bill_info(billinfo,i)
  count = billinfo.count
  render partial: "info", locals: {billinfo: billinfo, i: i} 
  
  end
  
end