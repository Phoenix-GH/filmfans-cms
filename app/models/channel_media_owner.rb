class ChannelMediaOwner < ActiveRecord::Base
  belongs_to :channel
  belongs_to :media_owner
end
