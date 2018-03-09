class MediaOwnerModerator < ActiveRecord::Base
  belongs_to :admin
  belongs_to :media_owner
end
