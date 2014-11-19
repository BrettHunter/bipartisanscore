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
i = 0  
Legislatorscore.all.each do |l|
  party_percentage = Legislatorscore.calculate_party_percentage(l.bioguide_id)
  yea_votes = Legislatorscore.calculate_yea_votes(l.bioguide_id)
  nay_votes = Legislatorscore.calculate_nay_votes(l.bioguide_id)
  bipartisan_yea_votes = Legislatorscore.calculate_bipartisan_yea_votes(l.bioguide_id)
  bipartisan_nay_votes = Legislatorscore.calculate_bipartisan_nay_votes(l.bioguide_id)
  bipartisan_votes = Legislatorscore.calculate_bipartisan_votes(l.bioguide_id)
  effective_bipartisan_votes = Legislatorscore.calculate_effective_bipartisan_votes(l.bioguide_id)
  chamberparty_rank = Legislatorscore.chamberparty_rank(l.chamberparty,l.mocscore)
  chamberparty_count = Legislatorscore.chamberparty_count(l.chamberparty)
  l.update(:party_percentage => party_percentage, :yea_votes => yea_votes, :nay_votes => nay_votes, :bipartisan_yea_votes => bipartisan_yea_votes,
    :bipartisan_nay_votes => bipartisan_nay_votes, :bipartisan_votes => bipartisan_votes, :effective_bipartisan_votes => effective_bipartisan_votes, 
    :chamberparty_rank => chamberparty_rank, :chamberparty_count => chamberparty_count)
  
  i +=1
  puts i
end
  