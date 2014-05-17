module Twitter3
  class Follower < ActiveRecord::Base
    # attr_accessible :title, :body
    belongs_to :user
  	belongs_to :user
  end
end
