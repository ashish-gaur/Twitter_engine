module Twitter3
  class User < ActiveRecord::Base
    # attr_accessible :title, :body
    attr_accessible :username, :email, :password, :password_confirmation, :confirmed, :token
  #has_many : :tweet_relationships
  has_many :tweets, foreign_key: 'user_id',  dependent: :destroy

  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  attr_accessor :password
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true #password_confirmation attr
  validates_length_of :password, :in => 6..20

  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if password.present?
      self.encrypted_password= self.password
    end
  end

  def clear_password
    self.password = nil
  end

  def self.delete_user

  end

  def self.authenticate(username_or_email, login_password)
    #puts "############## #{username_or_email}"
    if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end

    if user
      if user.encrypted_password == login_password && user.confirmed
        return user
      elsif !user.confirmed
        return user
      end
    else
      return false
    end
  end

  def self.search(username, current_user)
    username = username.downcase
    search_condition = username + "%"
    if username.length != 0
      followed_ids = current_user.followed_users.where("relationships.accept=true AND users.confirmed = true AND users.username LIKE ?", search_condition).pluck(:id)
      followed_ids.append current_user.id
      unless followed_ids.blank?
        where('users.confirmed = true AND lower(username) LIKE ? AND users.id NOT IN (?)', search_condition, followed_ids)
      else
        find(:all, :conditions => ['users.confirmed = true AND lower(username) LIKE ?', search_condition])
      end
    end
  end

  end
end
