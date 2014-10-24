require 'active_support/concern'

module Common
  extend ActiveSupport::Concern
  
  included do
  end
  
  
  module ClassMethods
    
    def photo_url(bio_id)
      if bio_id == "w000818"
        return ActionController::Base.helpers.asset_url("bio.svg");
      else
        url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
      end
    end
    
    def bipartisan_descriptor(bp_score)
      if bp_score > 90
        descriptor = "Extremely Bipartisan"
      elsif bp_score > 75
        descriptor = "Very Bipartisan"
      elsif bp_score > 50
        descriptor = "Somewhat Bipartisan"
      elsif bp_score > 25
        descriptor = "Very Partisan"
      else
        descriptor = "Extremely Partisan"
      end
    end
        
  end
end
