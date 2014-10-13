require 'active_support/concern'

module Common
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def photo_url(bio_id)
      if bio_id == "w000818"
        return ActionController::Base.helpers.asset_url("bio.svg");
      else
        url = "http://theunitedstates.io/images/congress/225x275/#{bio_id.upcase}.jpg"
      end
    end
  end
end
