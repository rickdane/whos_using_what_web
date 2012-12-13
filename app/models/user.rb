class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :remember_me, :token, :encrypted_password
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

  def encrypt_password
    if password.present?
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
  end

  def before_save
    encrypt_password
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
