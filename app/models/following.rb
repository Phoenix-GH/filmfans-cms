class Following < ActiveRecord::Base
  belongs_to :followed, polymorphic: true
  belongs_to :user
end
