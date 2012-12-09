class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, :presence => true
  attr_accessible :email, :name, :authorizations

  def apply_omniauth(omniauth)
    case omniauth['provider']
      when 'linkedin'
        self.apply_linkedin(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => (omniauth['credentials']['token'] rescue nil))
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
