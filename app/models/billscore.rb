class Billscore < ActiveRecord::Base
  validates :roll_id, uniqueness: true
  belongs_to :bill
  scope :recent, -> { order("billscores.updated_at DESC") }
  scope :retrieve_vote, -> { where("result = ? OR result = ? OR result = ?", "Passed", "Bill Passed", "Failed").order("billscores.voted_at DESC").first }
  scope :pertinent_vote, -> {where("pertinent_vote = ?", "true")}
  
  def self.get_last_vote_update_time
    update = Vote.recent.first.updated_at    
  end
    
  def self.get_last_billscore_update_time
    update = Billscore.recent.first.updated_at    
  end
    
  def self.calculate_yea_nay(roll_id)
    vote_record = Vote.find_by roll_id: roll_id
    vote = vote_record.attributes
    yea_votes = vote.select {|k,v| v == "Yea"}
    nay_votes = vote.select {|k,v| v == "Nay"}    
    yea = yea_votes.count
    nay = nay_votes.count
    return yea, nay
  end

  def self.calculate_dyes(roll_id)
    vote_record = Vote.find_by roll_id: roll_id
    vote = vote_record.attributes
    yea_votes = vote.select {|k,v| v == "Yea"}
    dyes = 0
    yea_keys = yea_votes.keys
    yea_keys.each do |bio_id| 
      voter = Legislator.find_by bioguide_id: bio_id
      if voter.party == "D"
        dyes +=1
      end
    end
    return dyes
  end

  def self.calculate_dno(roll_id)
    vote_record = Vote.find_by roll_id: roll_id
    vote = vote_record.attributes
    nay_votes = vote.select {|k,v| v == "Nay"}
    dno = 0
    nay_keys = nay_votes.keys
    nay_keys.each do |bio_id| 
      voter = Legislator.find_by bioguide_id: bio_id
      if voter.party == "D"
        dno +=1
      end
     end
    return dno
  end

  def self.calculate_ryes(roll_id)
    vote_record = Vote.find_by roll_id: roll_id
    vote = vote_record.attributes
    yea_votes = vote.select {|k,v| v == "Yea"}
    ryes = 0
    yea_keys = yea_votes.keys
    yea_keys.each do |bio_id| 
      voter = Legislator.find_by bioguide_id: bio_id
      if voter.party == "R"
        ryes +=1
      end
    end
    return ryes
  end

  def self.calculate_rno(roll_id)
    vote_record = Vote.find_by roll_id: roll_id
    vote = vote_record.attributes
    nay_votes = vote.select {|k,v| v == "Nay"}
    rno = 0
    nay_keys = nay_votes.keys
    nay_keys.each do |bio_id| 
      voter = Legislator.find_by bioguide_id: bio_id
      if voter.party == "R"
        rno +=1
      end
    end
    return rno
  end

  def self.calculate_dpos(dyes,dno)
    if dyes > dno
      dpos = "Yea"
    else dpos = "Nay"
    end
    return dpos
  end

  def self.calculate_rpos(ryes,rno)
    if ryes > rno
      rpos = "Yea"
    else rpos = "Nay"
    end
    return rpos
  end

  def self.calculate_drpos(dpos,rpos)
    if dpos == rpos
      drpos = "same"
    else 
      drpos = "different"
    end
    return drpos
  end

  def self.calculate_ddev(dyes,dno,dpos)
    if dpos == "Yea"
      ddev = dno
    else
      ddev = dyes
    end
    return ddev
  end

  def self.calculate_rdev(ryes,rno,rpos)
    if rpos == "Yea"
      rdev = rno
    else
      rdev = ryes
    end
    return rdev
  end

  def self.calculate_drdev(ddev,rdev)
    drdev = ddev + rdev    
  end

  def self.calculate_ddif(dyes,dno)
    dif = dyes - dno
    ddif = dif.abs   
  end

  def self.calculate_rdif(ryes,rno)
    dif = ryes - rno
    rdif = dif.abs    
  end

  def self.calculate_drdif(ddif,rdif)
    drdif = ddif + rdif    
  end

  def self.calculate_pscore(drpos,drdev,drdif)
    if drpos == "different"
      pscore = drdif 
    else
      pscore = drdev
    end  
   return pscore
  end

  def self.find_result(roll_id)
    record = Vote.find_by roll_id: roll_id
    result = record.result    
  end
    
  def self.find_chamber(roll_id)
    record = Vote.find_by roll_id: roll_id
    chamber = record.chamber      
  end  
    
  def self.calculate_global_rank(roll_id)
    record = Billscore.find_by roll_id: roll_id
    score = record.pscore
    array = Billscore.all.pluck(:combined_pscore)
    scores = array.count
    lessarray = array.select { |n| n >= score }
    lessers = lessarray.count
    global_rank = lessers * 100 / scores  
  end

  def self.calculate_chamber_rank(bill_id,chamber,roll_id)  
    record = Billscore.find_by roll_id: roll_id
    score = record.pscore
    array = Billscore.where("chamber = ?", chamber).pluck(:pscore)
    scores = array.count
    lessarray = array.select { |n| n <= score }
    lessers = lessarray.count
    chamber_rank = lessers * 100 / scores
  end
  
  def self.bill_table_id(bill_id)
    record = Bill.find_by bill_id: bill_id
    bill_table_id = record.id    
  end
  
  def self.get_bill_id(roll_id)
    record = Vote.find_by roll_id: roll_id
    bill_id = record.bill_id
  end
  
  def self.get_voted_at(roll_id)
    record = Vote.find_by roll_id: roll_id
    voted_at = record.voted_at
  end  
  
  def self.db_writer(roll_id,yea,nay,dyes,dno,ryes,rno,dpos,rpos,drpos,ddev,rdev,drdev,ddif,rdif,drdif,pscore,chamber,result,bill_id,voted_at)
    if Billscore.where("roll_id = ?", roll_id).exists?
      record = Billscore.find_by roll_id: roll_id
      record.update(roll_id: roll_id, yea: yea, nay: nay, dyes: dyes, dno: dno, ryes: ryes, rno: rno, dpos: dpos, rpos: rpos,
        ddev: ddev, rdev: rdev, drdev: drdev, ddif: ddif, rdif: rdif, drdif: drdif, drpos: drpos, pscore: pscore, chamber: chamber,
        result: result, bill_id: bill_id, voted_at: voted_at)
      puts "#{roll_id} updated!"
    elsif Billscore.where("bill_id = ? AND chamber = ?", bill_id, chamber).exists?
      record = Billscore.where("bill_id = ? AND chamber = ?", bill_id, chamber)[0]
      record.update(roll_id: roll_id, yea: yea, nay: nay, dyes: dyes, dno: dno, ryes: ryes, rno: rno, dpos: dpos, rpos: rpos,
        ddev: ddev, rdev: rdev, drdev: drdev, ddif: ddif, rdif: rdif, drdif: drdif, drpos: drpos, pscore: pscore, chamber: chamber,
        result: result, bill_id: bill_id, voted_at: voted_at)
    else
      Billscore.create(roll_id: roll_id, yea: yea, nay: nay, dyes: dyes, dno: dno, ryes: ryes, rno: rno, dpos: dpos, rpos: rpos,
        ddev: ddev, rdev: rdev, drdev: drdev, ddif: ddif, rdif: rdif, drdif: drdif, drpos: drpos, pscore: pscore, chamber: chamber,
        result: result, bill_id: bill_id, voted_at: voted_at)
      puts "#{roll_id} created!"
    end
  end
  
  def bill_rank(id)
    bill = Bill.find_by(id: id)
    rel = bill.billscore.count
    factor = bill.billscore.first.combined_pscore
    array = Billscore.where("chamber = ?", bill.billscore.first.chamber).pluck('combined_pscore')
    array.sort!
    rank = array.index(factor) + 1 
    count = array.count
  return rank, count
  end
  
   def self.combined_opposition_factor(bill_id)
    ary = Billscore.where(bill_id: bill_id).pluck('pscore')
    factor = ary.inject(:+)    
  end
  
end
