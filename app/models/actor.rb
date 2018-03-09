class Actor < ActiveRecord::Base

  scope :actors, -> { where("job = 'actor'") }
  scope :crew, -> { where("job <> 'actor'")}
  scope :directors, -> { where("job = 'director'") }
  scope :writers, -> { where("job = 'writer'") }

end
