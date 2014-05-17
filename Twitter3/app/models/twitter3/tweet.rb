module Twitter3
  class Tweet < ActiveRecord::Base
    # attr_accessible :title, :body
    belongs_to :user
  #has_one :user
  #has_one :owner, through: :tweets, source: :user_id
  attr_accessible :tweet, :user_id
  validates :user_id, presence: true
  validates :tweet, :length => { in: 20..100 }
  end
end
