class Provider < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :auth_token
  belongs_to :user

  def self.authenticate(auth, user_signed_in=nil, kind)
    if user_signed_in || self.find_by_uid(auth.uid)
      user = user_signed_in || self.find_by_uid(auth.uid).user
      
      unless user.providers.where(provider: auth.provider).first
        create_provider(auth.provider, auth.uid, user.id, auth.credentials.token)
      end

      user.populate_user_fields(auth, user, kind)
      user.save
      user
    else #there is no logged in user or user registered with those fields, lets create one:
      user = User.new
      user.populate_user_fields(auth, user, kind)
      user.save

      create_provider(auth.provider, auth.uid, user.id, auth.credentials.token) if user.persisted?
      user
    end
  end

  def self.create_provider(provider, uid, user_id, auth_token)
    self.create!(provider: provider, uid: uid, user_id: user_id, auth_token: auth_token)
  end

end
