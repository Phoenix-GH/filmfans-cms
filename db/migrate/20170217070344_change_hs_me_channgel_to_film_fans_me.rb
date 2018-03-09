class ChangeHsMeChanngelToFilmFansMe < ActiveRecord::Migration
  def change
    execute <<-SQL
      update channels set name = '#FILMFANSME', key = 'FILMFANSME' where key = 'HOTSPOTME';
    SQL
  end
end
