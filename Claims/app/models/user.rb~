class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable, :recoverable, :registerable, :encryptable
  has_many :claims

  validates :email, email_format: { message: "doesn't look like an email address" }
  validates :email, presence: true
  validates :email, uniqueness: true
  
  validates :password, :presence => true, :confirmation => true, :length => {:within => 6..40}

 def after_password_reset
  # self.update_attribute(:invite_code, nil)
 end

def self.options_for_select
  order('LOWER(email)').map { |e| [e.email, e.id] }
end

 attr_accessor :login
 

 def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_hash).first
      end
    end 


def active_for_authentication?
  super && self.active? 
end

def inactive_message
  "Sorry, this account has been deactivated."
end


end
