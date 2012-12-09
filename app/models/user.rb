class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :remember_me, :token
  has_many :authorizations
  validates :email, :presence => true
  attr_accessible :name, :authorizations

  def apply_omniauth(omniauth)
    case omniauth['provider']
      when 'linkedin'
        self.apply_linkedin(omniauth)
    end
    #, :token => (omniauth['credentials']['token'] rescue nil)
    authorizations.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end


  protected

  def apply_linkedin(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
      self.email = (extra['email'] rescue '')
    end
  end

  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'])
  end


end
