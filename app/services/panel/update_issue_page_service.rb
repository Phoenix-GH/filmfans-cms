class Panel::UpdateIssuePageService

  def initialize(issue_page, form)
    @issue_page = issue_page
    @form = form
  end

  def call
    return false unless @form.valid?

    update_issue_page
  end

  private
  def update_issue_page
    attributes_to_update = @form.attributes

    unless @form.image_attributes&.blank?
      attributes_to_update = attributes_to_update.merge(image: @form.image_attributes)
      puts attributes_to_update
    end
    @issue_page.update_attributes(attributes_to_update)
  end

end
