class Panel::UpdateIssueService
  attr_reader :issue

  def initialize(issue, form)
    @issue = issue
    @form = form
  end

  def call
    return false unless @form.valid?

    get_volume # Volumes are unused and should be removed
    update_issue
  end
  private

  def get_volume
    @magazine = Magazine.find(@form.magazine_id)
    @volume = @magazine.volumes.find_or_create_by(year: @form.attributes[:publication_date].year)
  end

  def update_issue
    @issue.update_attributes(@form.attributes.merge(
                              volume_id: @volume.id,
                              cover_image_attributes: @form.cover_image_attributes)
                            )
  end

end
