FactoryGirl.define do
  factory :bill do      
  end
  
  factory :legislator do
    bioguide_id "j000296"
    party "D"
  end
  
  factory :vote do
    sequence(:roll_id) { |n| "#{n}-2014" }
    j000296 "Yea"
    c001102 "Nay"
  end
  
  factory :billscore_vote, class: Vote do
    roll_id "0-2014"
    j000296 "Yea"
    c001102 "Nay"
  end
    
  factory :billscore do
  end
  
end