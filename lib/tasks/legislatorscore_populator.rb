
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
  