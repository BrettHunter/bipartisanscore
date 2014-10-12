class Legislatorscore < ActiveRecord::Base
  validates :bioguide_id, uniqueness: true
  serialize  :each_vote_points, Hash
  belongs_to :legislator, foreign_key: "legislator_id"
  scope :recent, -> { order("legislatorscores.updated_at DESC") }
  scope :top, -> { order("legislatorscores.bipartisanscore DESC") }
  scope :bottom, -> { order("legislatorscores.bipartisanscore ASC") }
  
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
      if result.include? "Passed" 
        voteresult = "Yea"
      elsif result.include? "Agreed" 
        voteresult = "Yea"
      elsif result.include? "Failed" 
        voteresult = "Nay"
      elsif result.include? "Rejected" 
        voteresult = "Nay"
      end    
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
      if result.include? "Passed" 
        voteresult = "Yea"
      elsif result.include? "Agreed" 
        voteresult = "Yea"
      elsif result.include? "Failed" 
        voteresult = "Nay"
      elsif result.include? "Rejected" 
        voteresult = "Nay"
      end    
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
    
  def self.get_pointed_votes(leg_id)
    record = Legislatorscore.find_by legislator_id: leg_id
    hsh = record.each_vote_points
    obj = hsh.select { |k,v| v > 0 }
    rtn = Hash[obj.sort_by{|k, v| v}.reverse]     
  end    
  
end
