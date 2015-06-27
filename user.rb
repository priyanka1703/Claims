class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :claims
  validates :username, email_format: { message: "doesn't look like an email address" }
  validates :username, presence: true
  validates :username, uniqueness: true
  
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40}
end
