class Legislatorscore < ActiveRecord::Base
  validates :bioguide_id, uniqueness: true
  serialize  :each_vote_points, Hash
  belongs_to :legislator, foreign_key: "legislator_id"
  scope :recent, -> { order("legislatorscores.updated_at DESC") }
  scope :top, -> { order("legislatorscores.bipartisanscore DESC") }
  scope :bottom, -> { order("legislatorscores.bipartisanscore ASC") }
  scope :in_office, -> { joins(:legislator).where("in_office = ?", "t")}
  
  def self.get_last_vote_update_time()
    update = Vote.recent.first.updated_at    
  end
    
  def self.get_last_legislatorscore_update_time()
    record = Legislatorscore.recent.first  
    if record.blank?
      return nil
    else
      update = record.updated_at
    end
    return update
  end   

  def self.calculate_mocvts(bio_id)    
    yea = Vote.where("#{bio_id} = ? AND pertinent_vote = ?", "Yea", "true").pluck(bio_id)
    nay = Vote.where("#{bio_id} = ? AND pertinent_vote = ?", "Nay", "true").pluck(bio_id)
    mocvts = yea.count + nay.count
  end
  
  def self.calculate_chamber_votes(chamber)
    count = Vote.where("chamber = ? AND pertinent_vote = ?", "#{chamber}", "true").count
  end
  
  def self.determine_vote_penalty(bio_id)
    chamber = determine_chamber(bio_id)
    chamber_count = calculate_chamber_votes(chamber)
    moc_count = calculate_mocvts(bio_id)
    if chamber_count * 0.75 > moc_count
      penalty = true
    else 
      penalty = false
    end
    return penalty
  end
  
  def self.determine_voteresult(result)
    if result.include? "Passed" 
      voteresult = "Yea"
    elsif result.include? "Agreed" 
      voteresult = "Yea"
    elsif result.include? "Failed" 
      voteresult = "Nay"
    elsif result.include? "Rejected" 
      voteresult = "Nay"
    end
    return voteresult
  end
    
    
  
  def self.calculate_mocpts(bio_id)
    mocpts = 0
    legrecord = Legislator.find_by bioguide_id: bio_id
    mocparty = legrecord.party
    ppos = nil
    if mocparty == "R" 
      ppos = "rpos"
    else 
      ppos = "dpos"
    end
    i = 0
    obj = Vote.where("#{bio_id} != ? AND pertinent_vote = ? AND chamber = ?", "nil", "true", legrecord.chamber).each do |record|
      mocpos = record.send("#{bio_id}")
      bill = Billscore.find_by roll_id: record.roll_id
      ippos = bill.send("#{ppos}")  
      result = bill.result    
      voteresult = determine_voteresult(result)
      if mocpos != ippos
        i = 1
      end
      if mocpos != ippos && mocpos == "Yea"
        i = 2
      end
      if mocpos != ippos && mocpos == "Yea" && mocpos == voteresult
        i = 3
      end  
      if mocpos == "Not Voting"
        i = 0
      end
      if mocpos == nil
        i = 0
      end
      if mocpos == "Present"
        i = 0
      end
      if bill.dpos == bill.rpos && mocpos != ippos
        i = 0
      end
      imocpts = i * bill.pscore
      mocpts +=imocpts
      imocpts = 0
      i = 0    
    end   
    return mocpts
  end
  
  def self.determine_ppos(mocparty)
    if mocparty == "R" 
      ppos = "rpos"
    else 
      ppos = "dpos"
    end
    return ppos
  end
  

  def self.each_vote_points(bio_id)
    hsh = {}
    legrecord = Legislator.find_by bioguide_id: bio_id
    mocparty = legrecord.party
    ppos = nil
    if mocparty == "R" 
      ppos = "rpos"
    else 
      ppos = "dpos"
    end
    i = 0
    obj = Vote.where("#{bio_id} != ? AND pertinent_vote = ? AND chamber = ?", "nil", "true", legrecord.chamber).each do |record|
      mocpos = record.send("#{bio_id}")
      bill = Billscore.find_by roll_id: record.roll_id
      ippos = bill.send("#{ppos}")  
      result = bill.result    
      voteresult = determine_voteresult(result)  
      if mocpos != ippos
        i = 1
      end
      if mocpos != ippos && mocpos == "Yea"
        i = 2
      end
      if mocpos != ippos && mocpos == "Yea" && mocpos == voteresult
        i = 3
      end  
      if mocpos == "Not Voting"
        i = 0
      end
      if mocpos == nil
        i = 0
      end
      if mocpos == "Present"
        i = 0
      end
      if bill.dpos == bill.rpos && mocpos != ippos
        i = 0
      end   
      imocpts = i * bill.pscore
      if imocpts > 0
        hsh["#{record.bill_id}"] = imocpts
      end
      imocpts = 0
      i = 0    
    end  
    return hsh
  end

  def self.calculate_mocscore(mocvts,mocpts)
    if mocvts > 0
      mocscore = mocpts.fdiv(mocvts).round(2)
    else 
      mocscore = 0
    end  
    return mocscore
  end
  
  def self.determine_chamber(bio_id)
      record = Legislator.find_by bioguide_id: bio_id
      chamber = record.chamber      
  end

  def self.determine_party(bio_id)
      record = Legislator.find_by bioguide_id: bio_id
      party = record.party     
  end
    
  def self.legislator_id(bio_id)
    record = Legislator.find_by bioguide_id: bio_id
    id = record.id
  end

  def self.legislatorscore_writer(bio_id,mocvts,mocpts,mocscore,chamberparty,legislator_id,each_vote_points) 
    record =  Legislatorscore.find_by bioguide_id: bio_id
    if record != nil
      record.update(:bioguide_id => bio_id, :mocvts => mocvts, :mocpts => mocpts, :mocscore => mocscore, 
        :chamberparty => chamberparty, :legislator_id => legislator_id, :each_vote_points => each_vote_points)
    else
      Legislatorscore.create(bioguide_id: bio_id, mocvts: mocvts, mocpts: mocpts, mocscore: mocscore, 
        chamberparty: chamberparty, legislator_id: legislator_id, each_vote_points: each_vote_points)
    end
  end
  
  def self.assign_chamberparty(chamber,party)
    if party == "D" && chamber == "house"
      chamberparty = "dem_house"
    elsif party == "D" && chamber == "senate"
      chamberparty = "dem_senate"
    elsif party == "R"  && chamber == "house"
      chamberparty = "rep_house"
    elsif party == "R" && chamber == "senate"
      chamberparty = "rep_senate"
    elsif party == "I"
      chamberparty = "independent"
    end
    return chamberparty    
  end
  
  def self.calculate_bipartisanscore(bio_id)
    record = Legislatorscore.find_by bioguide_id: bio_id 
    chamberparty = record.chamberparty
    score = record.mocscore
    if chamberparty == "dem_house"
      array = Legislatorscore.where(chamberparty: 'dem_house').pluck(:mocscore)
    elsif chamberparty == "dem_senate"
      array = Legislatorscore.where(chamberparty: 'dem_senate').pluck(:mocscore)
    elsif chamberparty == "rep_house"
      array = Legislatorscore.where(chamberparty: 'rep_house').pluck(:mocscore)
    elsif chamberparty == "rep_senate"
      array = Legislatorscore.where(chamberparty: 'rep_senate').pluck(:mocscore)  
    else
      bipartisanscore = 0
      return bipartisanscore
    end
    scores = array.count
    lessarray = array.select { |n| n < score }
    lessers = lessarray.count
    bipartisanscore = lessers * 100 / scores
    penalty = determine_vote_penalty(record.bioguide_id)
    if penalty == true  
      bipartisanscore -= 25
    end
    if bipartisanscore < 0
      bipartisanscore = 0
    end
    return bipartisanscore
  end

  def self.calculate_globalscore(bio_id)
    record = Legislatorscore.find_by bioguide_id: bio_id
    score = record.mocscore
    array = Legislatorscore.pluck(:mocscore)
    scores = array.count
    lessarray = array.select { |n| n < score }
    lessers = lessarray.count
    globalscore = lessers * 100 / scores
    return globalscore
  end
    
  def self.get_pointed_votes(bio_id)
    record = Legislatorscore.find_by bioguide_id: bio_id
    hsh = record.each_vote_points
    obj = hsh.select { |k,v| v > 0 }
    rtn = Hash[obj.sort_by{|k, v| v}.reverse]     
  end
  
  def self.get_voted_roll_ids(bio_id)
    ary = Vote.where("pertinent_vote = ? AND #{bio_id} = ? OR #{bio_id} = ? ", "true", "Yea", "Nay").pluck(:roll_id , :"#{bio_id}")
  end
  
  def self.get_vote_match_count(ary,ppos)
    i = 0
    ary.each do |r|
      val = Billscore.where("roll_id = ?", "#{r[0]}").pluck(:"#{ppos}")     
      if val[0] == r[1]
        i +=1        
      end    
    end  
  return i
  end
      
  
  def self.calculate_party_percentage(bio_id)
    mocvts = calculate_mocvts(bio_id)
    ary = get_voted_roll_ids(bio_id)
    party = determine_party(bio_id)
    ppos = determine_ppos(party)
    match_count = get_vote_match_count(ary,ppos)    
    if mocvts > 0
      percentage = (match_count * 100) / mocvts  
    else
      percentage = 0
    end
  end

  def self.calculate_yea_votes(bio_id)
    yea = Vote.where("#{bio_id} = ? AND pertinent_vote = ?", "Yea", "true").pluck(bio_id)
    return yea.count
  end

  def self.calculate_nay_votes(bio_id)
    nay = Vote.where("#{bio_id} = ? AND pertinent_vote = ?", "Nay", "true").pluck(bio_id)
    return nay.count
  end

  def self.calculate_bipartisan_yea_votes(bio_id)
    chamber = determine_chamber(bio_id)
    hsh = get_pointed_votes(bio_id)
    ary = hsh.keys
    i = 0
    ary.each do |b|
      obj = Vote.find_by("chamber = ? AND bill_id = ? AND pertinent_vote = ?", "#{chamber}", "#{b}", "true").send("#{bio_id}")
      if obj == "Yea"
        i +=1
      end
    end
    return i
  end

  def self.calculate_bipartisan_nay_votes(bio_id)
    chamber = determine_chamber(bio_id)
    hsh = get_pointed_votes(bio_id)
    ary = hsh.keys
    i = 0
    ary.each do |b|
      obj = Vote.find_by("chamber = ? AND bill_id = ? AND pertinent_vote = ?", "#{chamber}", "#{b}", "true").send("#{bio_id}")
      if obj == "Nay"
        i +=1
      end
    end
    return i
  end

  def self.calculate_bipartisan_votes(bio_id)
    hsh = get_pointed_votes(bio_id)
    return hsh.count
  end

def self.calculate_effective_bipartisan_votes(bio_id)
    chamber = determine_chamber(bio_id)
    hsh = get_pointed_votes(bio_id)
    ary = hsh.keys
    i = 0
    ary.each do |b|
      mocvote = Vote.find_by("bill_id = ? AND chamber = ? AND pertinent_vote = ?", "#{b}", "#{chamber}", "true").send("#{bio_id}")
      result = Billscore.find_by("bill_id = ? AND chamber = ?", "#{b}", "#{chamber}").result
      voteresult = determine_voteresult(result)
      if mocvote == voteresult
        i +=1
      end
    end
    return i
  end
    
  def self.chamberparty_count(chamberparty)  
    count = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").count
  end

  def self.chamberparty_rank(chamberparty,mocscore)
    array = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('mocscore')
    array.sort!.reverse!
    rank = array.index(mocscore) + 1 
  end 

  def self.average_bipartisan_votes(chamberparty)
    arr = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('bipartisan_votes')
    avg = arr.inject(:+) / arr.size
  end
  
  def self.average_bipartisan_points(chamberparty)
    arr = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('mocpts')
    avg = arr.inject(:+) / arr.size
  end
  
  def self.average_party_percentage(chamberparty)
    arr = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('party_percentage')
    avg = arr.inject(:+) / arr.size
  end

  def self.average_yea_votes(chamberparty)
    arr = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('yea_votes')
    avg = arr.inject(:+) / arr.size
  end
  
  def self.average_nay_votes(chamberparty)
    arr = Legislatorscore.where("chamberparty = ?", "#{chamberparty}").pluck('nay_votes')
    avg = arr.inject(:+) / arr.size
  end
    

end
