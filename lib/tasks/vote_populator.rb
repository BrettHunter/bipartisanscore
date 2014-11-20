
  api_vote_count = Vote.get_api_vote_count
  db_vote_count = Vote.get_db_vote_count  
  if db_vote_count == api_vote_count
    abort("No updated Votes!")
    
  end    
  i = 0
until Vote.get_db_vote_count == api_vote_count do
  apirecord = Vote.get_vote(i)
  bill_id = apirecord['bill_id']
  chamber = apirecord['chamber']
  result = apirecord['result']
  roll_id = apirecord['roll_id']
  voted_at = apirecord['voted_at']
  vote_type = apirecord['vote_type']
  roll_type = apirecord['roll_type']
  question = apirecord['question']
  if Vote.where(roll_id: roll_id).blank?      
     Vote.create(bill_id: bill_id, chamber: chamber, result: result, roll_id: roll_id, voted_at: voted_at, vote_type: vote_type, 
       roll_type: roll_type, question: question)
     record = Vote.find_by(roll_id: roll_id)
     apirecord.voter_ids.keys.each do |id|        
       v = id
      
       record.update("#{id}".upcase => apirecord.voter_ids[v])        
     end
     puts "Vote record updated for #{roll_id} #{bill_id}"
  else
    puts "Vote already exists for #{roll_id} #{bill_id}"    
  end
  i +=1
  puts "#{i}, db = #{db_vote_count} api = #{api_vote_count}"
  end
  Vote.pertinent_vote()
  

