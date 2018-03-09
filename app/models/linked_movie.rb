class LinkedMovie < ActiveRecord::Base
  belongs_to :movie
  belongs_to :movies_container

  default_scope { order('position') }
end
