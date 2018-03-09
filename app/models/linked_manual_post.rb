class LinkedManualPost < ActiveRecord::Base
  belongs_to :manual_post
  belongs_to :linked_manual_post_container

  default_scope { order('position') }
end