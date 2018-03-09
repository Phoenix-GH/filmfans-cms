class Source < ActiveRecord::Base
  belongs_to :source_owner, polymorphic: true
  has_many :posts, dependent: :destroy

  def website_with_name
    "#{website} (#{name})"
  end

  def self.allowed_websites
    ['facebook', 'instagram', 'twitter']
  end
end
