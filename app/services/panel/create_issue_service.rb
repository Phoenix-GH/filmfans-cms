class Panel::CreateIssueService
  attr_reader :issue

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    get_volume # Volumes are unused and should be removed
    create_issue
    create_cover_image
  end

  private

  def get_volume
    @magazine = Magazine.find(@form.magazine_id)
    @volume = @magazine.volumes.find_or_create_by(year: @form.attributes[:publication_date].year)
  end

  def create_issue
    @issue = Issue.create(@form.attributes.merge(volume_id: @volume.id))
  end

  def create_cover_image
    @issue.create_cover_image(@form.cover_image_attributes)
  end

end
