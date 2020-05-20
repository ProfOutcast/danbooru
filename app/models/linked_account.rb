class LinkedAccount < ApplicationRecord
  belongs_to :user

  enum site: {
    discord: 0,
    deviantart: 1,
  }

  def self.visible(user)
    if user.is_admin?
      all
    else
      where(user: user)
    end
  end

  def self.search(params = {})
    q = super
    q = q.search_attributes(params, :user, :site, :account_id)
    q = q.apply_default_order(params)
    q
  end

  def self.api_attributes
    super - [:api_key, :account_data]
  end
end
