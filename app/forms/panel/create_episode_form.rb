class Panel::CreateEpisodeForm
  include ActiveModel::Model

  attr_accessor(
    :tv_show_season_id, :cover_image, :file, :title, :number, :specification,
    :tv_show_season_number, :tv_show_id, :file_cache
  )


  validates :title, :tv_show_season_number, :number, presence: true

  def attributes
    {
      tv_show_season_id: tv_show_season_id,
      cover_image: cover_image,
      file: file,
      title: title,
      number: number,
      specification: specification,
      tv_show_season_number: tv_show_season_number,
      tv_show_id: tv_show_id,
      file_cache: file,
    }
  end

  def attributes_for_create
    attributes.slice(:cover_image, :file, :title, :number, :specification)
  end

  def cover_image_attributes
    cover_image || {}
  end
end


