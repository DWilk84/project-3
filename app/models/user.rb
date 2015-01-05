class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook] #:google_oauth2, :twitter, 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :images, dependent: :destroy
  has_many :mosaics, dependent: :destroy
  has_many :providers, dependent: :destroy

  def self.map_authentication_to_user_properties(authentication_object)
    authentication_object.slice(:info, :provider, :uid, :user_id, :credentials)
  end

  def populate_user_fields(auth, user, kind)
    case kind
    when "Facebook"
      user.name = auth.info.name if !auth.info.name.nil? && user.name.blank?
      user.email = auth.info.email if !auth.info.email.nil? && user.email.blank?
      # user.image = auth.info.image if !auth.info.image.nil? && user.image.blank?
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!) 
    # when "Twitter"
    #   user.name = auth.info.name if !auth.info.name.nil? && user.name.blank?
    #   user.image = auth.info.image if !auth.info.image.nil? && user.image.blank?
    #   user.username = auth.info.nickname if !auth.info.nickname.nil? && user.username.blank?
    #   user.skip_confirmation! if user.respond_to?(:skip_confirmation!) 
    # when "Google"
    #   user.name = auth.info.name if !auth.info.name.nil? &&user.name.blank?
    #   user.image = auth.info.image if !auth.info.image.nil? && user.image.blank?
    #   user.email = auth.info.email if !auth.info.email.nil? && user.email.blank?
    #   user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if auth = session["devise.authentication"]

        user.username = auth.info.nickname if user.username.blank?
        user.name = auth.info.name if user.name.blank?
        user.email = auth.info.email if user.email.blank?
        # user.image = auth.info.image if user.image.blank?
        user.skip_confirmation! if user.respond_to?(:skip_confirmation!) # don't require email confirmation
      end
    end
  end
  
  def self.get_auth_token(user)
    user.providers.where(provider: "facebook").first.auth_token
  end

  def self.get_fb_albums(user)
    token = User.get_auth_token(user)
    graph = Koala::Facebook::API.new(token)
    
    albums = graph.get_connections("me", "albums")
    
    fb_albums = albums.map do |a|
      hash = {}
      hash['id'] = a['id']
      hash['name'] = a['name']
      pics = graph.get_connections(hash['id'], "photos")
      hash['urls'] = pics.map do |pic|
        pic['images'].last['source']
      end  
      hash
    end
  end

end
