last_vote_update_time = Legislatorscore.get_last_vote_update_time()
  last_legislatorscore_update_time = Legislatorscore.get_last_legislatorscore_update_time() 
  if last_legislatorscore_update_time == nil
    
    elsif last_legislatorscore_update_time > last_vote_update_time    
    abort("No updated Votes!")    
  end   
  
  i = 0
leg = Legislator.all.pluck('bioguide_id')
  leg.each do |l|     
    mocvts = Legislatorscore.calculate_mocvts(l)
    i += 1
    puts i
    mocpts = Legislatorscore.calculate_mocpts(l)
    evp = Legislatorscore.each_vote_points(l)
    each_vote_points = Hash[evp.sort_by{|k, v| v}.reverse] 
    mocscore = Legislatorscore.calculate_mocscore(mocvts,mocpts)
    mocchamber = Legislatorscore.determine_chamber(l)
    mocparty = Legislatorscore.determine_party(l)
    chamberparty = Legislatorscore.assign_chamberparty(mocchamber,mocparty)
    legislator_id = Legislatorscore.legislator_id(l)
    Legislatorscore.legislatorscore_writer(l,mocvts,mocpts,mocscore,chamberparty,legislator_id,each_vote_points)    
    puts "#{l} (a #{mocparty} working in the #{mocchamber}) has #{mocvts} votes and has accumulated #{mocpts} points for a score of #{mocscore}"
  end
  
  Legislatorscore.all.each do |l|
    bipartisanscore = Legislatorscore.calculate_bipartisanscore(l.bioguide_id)
    globalscore = Legislatorscore.calculate_globalscore(l.bioguide_id)
    l.update(:bipartisanscore => bipartisanscore, :globalscore => globalscore)
  end
  
  
  