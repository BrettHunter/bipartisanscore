 
count_object = Legislator.get_legislators(1)
  count = Legislator.get_count(count_object)
  i = 0
  until i == count do    
  leg = Legislator.get_legislators(i)
  input = leg.results.first  
  record = Legislator.find_by bioguide_id: input.bioguide_id
  if record != nil
    record.update(title: input.title, first_name: input.first_name, last_name: input.last_name, party: input.party, state: input.state, 
      bioguide_id: input.bioguide_id.downcase,  chamber: input.chamber, in_office: input.in_office, gender: input.gender, 
      website: input.website, term_start: input.term_start, term_end: input.term_end)
  else 
    Legislator.create(title: input.title, first_name: input.first_name, last_name: input.last_name, party: input.party, 
      state: input.state, bioguide_id: input.bioguide_id.downcase, chamber: input.chamber, in_office: input.in_office, 
      gender: input.gender, website: input.website, term_start: input.term_start, term_end: input.term_end)
  end
    i +=1
    puts i
  end
    
