class Vote < ActiveRecord::Base
  validates :roll_id, uniqueness: true
  scope :recent, -> { order("votes.updated_at DESC") }  
  scope :retrieve_vote, -> { where("vote_type = ? OR vote_type = ? OR vote_type = ?", "passage", "amendment", "cloture").order("votes.voted_at DESC").first }
  scope :pertinent_vote, -> {where("pertinent_vote = ?", "true")}
  belongs_to :bill 
  
  def self.get_api_vote_count
    obj = Congress.votes(page: "1", per_page: "1", congress: "113", fields: ["roll_id"])
    count = obj['count']
  end
    
  def self.get_db_vote_count
    count = Vote.all.count
  end
    
  def self.pertinent_vote
    Vote.find_each(batch_size: 250) do |b|
    bill_id = b.bill_id
    chamber = b.chamber
      record = Vote.where("bill_id = ? AND chamber = ?", bill_id, chamber).retrieve_vote        
      if record == b
        b.update(pertinent_vote: "true")
      else
        b.update(pertinent_vote: "false")
      end       
    end
    return nil
  end
    
  def self.get_vote(i)
    obj = Congress.votes(page: i, per_page: "1", congress: "113", fields: ["bill_id", "roll_id", "voter_ids", "chamber", 
      "result", "voted_at", "vote_type", "roll_type", "question"])
    votes = obj.results[0]
    return votes
  end

end
