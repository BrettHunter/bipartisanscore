FactoryGirl.define do
  sequence(:roll_id) { |n| "#{n}-2014" } 
  
  factory :bill do      
  end
  
  factory :legislator do    
  end
  
  factory :legislatorscore do
  end
  
  
  factory :vote do
    roll_id  
  end
  
  factory :billscore do
    roll_id
  end  
  
  
end