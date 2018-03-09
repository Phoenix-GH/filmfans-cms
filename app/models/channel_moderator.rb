class ChannelModerator < ActiveRecord::Base
  belongs_to :admin
  belongs_to :channel
end
