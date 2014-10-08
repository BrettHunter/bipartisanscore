if db_update > api_update
    abort("no updates found...")    
  else
  api_update = Bill.get_last_api_update()
  db_update = Bill.get_last_db_update() 
  if db_update == nil
    db_update = "2013-01-03"
  end
if db_update > api_update
    abort("no updates found...")    
  else
    api_record_update = api_update
    i = 0
    until db_update > api_record_update do      
      api_obj = Bill.get_bill_from_api(i)
      api_record = api_obj.results[0]
      db_obj = Bill.find_by bill_id: api_record.bill_id
      if db_obj == nil
        Bill.create_bill(api_obj)
        puts "creating record..."
        api_record_update = api_record.last_action_at
      else        
        Bill.update_bill(api_obj,db_obj)
        puts "updating record..."
        api_record_update = api_record.last_action_at
      end      
    i +=1
    puts i    
    end


