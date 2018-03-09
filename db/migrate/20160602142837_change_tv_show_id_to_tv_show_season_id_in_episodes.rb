class ChangeTvShowIdToTvShowSeasonIdInEpisodes < ActiveRecord::Migration
  def change
    rename_column :episodes, :tv_show_id, :tv_show_season_id
    remove_column :episodes, :season
  end
end
